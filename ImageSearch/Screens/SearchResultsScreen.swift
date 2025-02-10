import UIKit
import SnapKit
import Combine

final class SearchResultsScreen: ISScreen<SearchResultsViewModel> {
    private let homeButton = UIButton()
    private let searchField = ISSearchField()
    private let preferencesButton = UIButton()
    private let totalResultsLabel = UILabel()
    private let relatedLabel = UILabel()
    private let relatedCollection = ISHorizontalCollectionView()
    private let resultsCollection: ISVerticalCollectionView

    override init(viewModel: SearchResultsViewModel) {
        resultsCollection = .init(dataProvider: viewModel, layout: UICollectionViewFlowLayout())
        super.init(viewModel: viewModel)
    }

    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configure()
        setConstraints()
    }
    
    private func setConstraints() {
        addSubviews(
            homeButton,
            searchField,
            preferencesButton,
            totalResultsLabel,
            relatedLabel,
            relatedCollection,
            relatedCollection
        )
    }
}

final class SearchResultsViewModel: ViewModel {
    struct Dependencies {
        let networkManager: NetworkManager
        let initialResults: APIImagesResponse
        let query: String
        let navigationHandler: () -> Void
    }

    private let dependencies: Dependencies
    private var disposalBag = Set<AnyCancellable>()

    @Published var images: [ISImage]

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        images = dependencies.initialResults.hits
    }
    
    func provideImage(for cell: ISMediaCell, at index: IndexPath) {
        dependencies.networkManager.downloadImage(from: images[index.item].previewURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak cell] result in
                switch result {
                case .success(let data): cell?.setImage(UIImage(data: data) ?? UIImage.notFound)
                case .failure(_): cell?.setImage(UIImage.notFound)
                }
            }
            .store(in: &disposalBag)
    }
}
