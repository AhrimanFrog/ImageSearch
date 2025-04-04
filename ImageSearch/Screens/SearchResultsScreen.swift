import UIKit
import SnapKit
import Combine

final class SearchResultsScreen: ISScreen<SearchResultsViewModel> {
    private let topBanner = UIView()
    private let header = ISHeaderBlock()
    private let totalResultsLabel = ISInfoLabel(frame: .zero)
    private let relatedLabel = ISCommentLabel(frame: .zero)
    private let relatedCollection: ISHorizontalCollectionView
    private let resultsCollection: ISVerticalCollectionView

    private var disposalBag = Set<AnyCancellable>()

    override init(viewModel: SearchResultsViewModel) {
        resultsCollection = .init(dataProvider: viewModel, layout: .mediaLayout(), cellType: ISSharedCell.self)
        relatedCollection = .init(viewModel: viewModel)
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
        bindViewModel()
    }

    private func configure() {
        backgroundColor = .systemGray5
        topBanner.backgroundColor = .systemBackground
        totalResultsLabel.text = String(localized: "\(viewModel.total.value)_free_images")
        relatedLabel.text = String(localized: "related")
        header.searchField.text = viewModel.query
        header.delegate = viewModel
    }

    private func bindViewModel() {
        viewModel.total
            .sink { [weak self] newTotal in
                self?.totalResultsLabel.text = String(localized: "\(newTotal)_free_images")
            }
            .store(in: &disposalBag)
    }

    private func setConstraints() {
        addSubviews(header, totalResultsLabel, relatedLabel, relatedCollection, resultsCollection, topBanner)

        header.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.lessThanOrEqualTo(60)
        }
        topBanner.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(header.snp.top)
        }
        totalResultsLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(header.snp.bottom).inset(-10)
            make.height.equalTo(22)
        }

        relatedLabel.snp.makeConstraints { make in
            make.top.equalTo(totalResultsLabel.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(32)
            make.width.equalTo(66)
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

final class SearchResultsViewModel: ViewModel, NetworkDataProvider, HeaderViewDelegate {
    private static let maximumTags = 8

    struct Dependencies {
        let networkManager: NetworkManager
        let preferences: CurrentValueSubject<Preferences, Never>
        let initialResults: APIImagesResponse
        var query: String
        let navigationHandler: NavigationHandler
        let share: (UIImage, String) -> Void
    }

    private var dependencies: Dependencies
    private var disposalBag = Set<AnyCancellable>()
    private var page: Int = 1

    let total: CurrentValueSubject<Int, Never>
    let images: CurrentValueSubject<[ISImage], Never>
    let related: CurrentValueSubject<[String], Never>
    let share: (UIImage, String) -> Void

    var query: String { dependencies.query }
    var navigationHandler: NavigationHandler { dependencies.navigationHandler }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        let hits = dependencies.initialResults.hits
        images = .init(hits)
        related = .init(SearchResultsViewModel.gatherTagsFromMedia(hits))
        total = .init(dependencies.initialResults.total)
        share = dependencies.share
    }

    func imagePublisher(for model: ISImage) -> AnyPublisher<UIImage, Never> {
        return dependencies.networkManager.downloadImage(from: model.largeImageURL)
    }

    func fetchMoreResults() {
        guard images.value.count < total.value else { return }
        page += 1
        dependencies.networkManager.getImages(
            query: query,
            page: page,
            userPreferences: dependencies.preferences.value
        )
            .sink { [weak self] result in
                switch result {
                case .success(let response): self?.images.value.append(contentsOf: response.hits)
                case .failure(let error): print(error.errorDescription)
                }
            }
            .store(in: &disposalBag)
    }

    func displayResults(of request: String) {
        dependencies.networkManager
            .getImages(query: request, page: 1, userPreferences: dependencies.preferences.value)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let respponse): self?.updateScreen(response: respponse, request: request)
                case .failure(let error): self?.navigationHandler(.failure(error))
                }
            }
            .store(in: &disposalBag)
    }

    func openPhotoScreen(forPhoto photo: ISImage) {
        let related = images.value.filter { $0.id != photo.id }.prefix(20)
        navigationHandler(.success(.photo(photo, Array(related))))
    }

    private func updateScreen(response: APIImagesResponse, request: String) {
        images.send(response.hits)
        related.send(SearchResultsViewModel.gatherTagsFromMedia(response.hits))
        total.send(response.total)
        dependencies.query = request
        page = 1
    }

    private static func gatherTagsFromMedia(_ media: [ISImage]) -> [String] {
        let joinedTags = media.reduce(into: []) { $0.append(contentsOf: $1.formattedTags) }.unique
        return Array(joinedTags.prefix(maximumTags))
    }
}
