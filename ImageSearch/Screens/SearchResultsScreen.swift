import UIKit
import SnapKit
import Combine

final class SearchResultsScreen: ISScreen<SearchResultsViewModel> {
    private let header = ISHeader()
    private let totalResultsLabel = ISInfoLabel(frame: .zero)
    private let relatedLabel = ISCommentLabel(frame: .zero)
    private let relatedCollection = ISHorizontalCollectionView()
    private let resultsCollection: ISVerticalCollectionView

    override init(viewModel: SearchResultsViewModel) {
        resultsCollection = .init(dataProvider: viewModel, layout: .mediaLayout())
        super.init(viewModel: viewModel)
    }

    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bindNavigation()
    }

    private func configure() {
        backgroundColor = .systemGray5
        totalResultsLabel.text = "\(viewModel.totalResults) Free Images"
        relatedLabel.text = "Related"
        header.searchField.text = viewModel.query
    }

    private func bindNavigation() {
        header.homeButton.addAction(UIAction { [weak self] _ in self?.viewModel.goTo(.start) }, for: .touchUpInside)
    }

    private func setConstraints() {
        addSubviews(header, totalResultsLabel, relatedLabel, relatedCollection, resultsCollection)

        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(140)
        }

        totalResultsLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(header.snp.bottom).inset(-10)
            make.height.equalTo(22)
        }

        relatedLabel.snp.makeConstraints { make in
            make.top.equalTo(totalResultsLabel.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(19)
            make.width.equalTo(48)
        }

        relatedCollection.snp.makeConstraints { make in
            make.top.height.equalTo(relatedLabel)
            make.leading.equalTo(relatedLabel.snp.trailing).inset(-16)
            make.trailing.equalToSuperview()
        }

        resultsCollection.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(relatedCollection.snp.bottom).inset(-10)
        }
    }
}

final class SearchResultsViewModel: ViewModel {
    struct Dependencies {
        let networkManager: NetworkManager
        let initialResults: APIImagesResponse
        let query: String
        let navigationHandler: (MainCoordinator.Destination) -> Void
    }

    private let dependencies: Dependencies
    private var disposalBag = Set<AnyCancellable>()
    private var page: Int = 1

    private(set) var images: CurrentValueSubject<[ISImage], Never>
    private(set) var related: CurrentValueSubject<Set<String>, Never>

    var totalResults: Int { dependencies.initialResults.total }
    var query: String { dependencies.query }
    var goTo: (MainCoordinator.Destination) -> Void { dependencies.navigationHandler }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        let hits = dependencies.initialResults.hits
        images = .init(hits)
        related = .init(hits.reduce(into: Set<String>()) { $0.formUnion($1.formattedTags) })
    }

    func provideImage(for cell: ISMediaCell, at index: IndexPath) {
        dependencies.networkManager.downloadImage(from: images.value[index.item].largeImageURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak cell] image in cell?.setImage(image) }
            .store(in: &disposalBag)
    }

    func fetchMoreResults() {
        guard images.value.count < totalResults else { return }
        page += 1
        dependencies.networkManager.getImages(query: query, page: page, userPreferences: Preferences())
            .sink { [weak self] result in
                switch result {
                case .success(let response):
                    let newImages = (self?.images.value ?? []) + response.hits
                    self?.images.send(newImages)
                case .failure(let error): print(error.errorDescription)
                }
            }
            .store(in: &disposalBag)
    }
}
