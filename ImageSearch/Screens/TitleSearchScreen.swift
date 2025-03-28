import UIKit
import SnapKit
import Combine

final class TitleSearchScreen: ISScreen<TitleSearchViewModel> {
    private let title = ISTitleLabel()
    private let searchField = ISDropDownSearchField()
    private let searchButton = ISButton(title: String(localized: "search"), image: .init(sfImage: .search))
    private let backgroundImage = UIImageView()

    private var preferencesSubscription: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configure()
        setConstraints()
    }

    private func bind() {
        searchField.inputField.addInputProcessor { [weak self] input in self?.viewModel.transitToResults(of: input) }
        searchButton.addAction(
            UIAction { [weak self] _ in
                guard let self, let text = searchField.inputField.text, !text.isEmpty else { return }
                guard searchField.inputField.isFirstResponder else { return viewModel.transitToResults(of: text) }
                searchField.inputField.endEditing(false)
            },
            for: .touchUpInside
        )
        preferencesSubscription = viewModel.preferences
            .map(\.imageType)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let host = self?.owner, host.isViewLoaded && self?.window != nil else { return }
                self?.searchField.currentTypeButton.setTitle(newValue.description, for: .normal)
            }
        searchField.currentTypeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                spawnTable(
                    forValue: viewModel.preferences.value.imageType,
                    ofComponent: searchField.currentTypeButton
                ) { [preferences = viewModel.preferences] in preferences.value.imageType = $0 }
            },
            for: .touchUpInside
        )
    }

    private func configure() {
        backgroundColor = .black
        backgroundImage.image = .init(resource: .titleBackground)
        backgroundImage.alpha = 0.5
    }

    private func setConstraints() {
        addSubviews(backgroundImage, title, searchField, searchButton)
        backgroundImage.snp.makeConstraints { $0.edges.equalToSuperview() }

        title.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(240)
            make.height.lessThanOrEqualTo(200)
        }

        searchField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(title.snp.bottom).inset(-50)
            make.height.equalTo(52)
        }

        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(searchField)
            make.top.equalTo(searchField.snp.bottom).inset(-20)
        }
    }
}

final class TitleSearchViewModel: ViewModel {
    let preferences: CurrentValueSubject<Preferences, Never>
    private let networkManager: NetworkManager
    private let requestTransitionToResults: (Result<(APIImagesResponse, String), ISNetworkError>) -> Void
    private var apiSubscription: AnyCancellable?

    init(
        networkManager: NetworkManager,
        preferences: CurrentValueSubject<Preferences, Never>,
        coordinatorNotifier: @escaping (Result<(APIImagesResponse, String), ISNetworkError>) -> Void
    ) {
        self.networkManager = networkManager
        self.preferences = preferences
        requestTransitionToResults = coordinatorNotifier
    }

    func transitToResults(of request: String) {
        apiSubscription = networkManager
            .getImages(query: request, page: 1, userPreferences: preferences.value)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let respponse): self?.requestTransitionToResults(.success((respponse, request)))
                case .failure(let error): self?.requestTransitionToResults(.failure(error))
                }
            }
    }
}
