import UIKit
import SnapKit
import Combine

final class SearchResultsScreen: ISScreen<SearchResultsViewModel> {
    private let header = ISHeader()
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
        configure()
        setConstraints()
    }

    private func configure() {
        backgroundColor = .systemGray5
        totalResultsLabel.text = String(viewModel.totalResults)
        relatedLabel.text = "Related"
    }

    private func setConstraints() {
        addSubviews(header, totalResultsLabel, relatedLabel, relatedCollection, resultsCollection)

        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
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
            make.width.equalTo(44)
        }

        relatedCollection.snp.makeConstraints { make in
            make.top.height.equalTo(relatedLabel)
            make.leading.equalTo(relatedLabel.snp.trailing).inset(16)
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
        let navigationHandler: () -> Void
    }

    private let dependencies: Dependencies
    private var disposalBag = Set<AnyCancellable>()

    @Published var images: [ISImage]

    var totalResults: Int { dependencies.initialResults.total }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        images = dependencies.initialResults.hits
    }

    func provideImage(for cell: ISMediaCell, at index: IndexPath) {
        dependencies.networkManager.downloadImage(from: images[index.item].previewURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak cell] image in cell?.setImage(image) }
            .store(in: &disposalBag)
    }
}
