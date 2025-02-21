import UIKit
import SnapKit
import Combine

class PhotoScreen: ISScreen<PhotoScreenViewModel> {
    private let header = ISHeaderBlock()
    private let photoImage = UIImageView()
    private let zoomButton = UIButton()
    private let photoInfoBlock = ISPhotoInfoBlock(frame: .zero)
    private let relatedLabel = ISInfoLabel()
    private let relatedCollection: ISVerticalCollectionView

    private var disposalBag = Set<AnyCancellable>()

    override init(viewModel: PhotoScreenViewModel) {
        relatedCollection = .init(dataProvider: viewModel, layout: .mediaLayout())
        super.init(viewModel: viewModel)
    }

    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configure()
        setConstraints()
    }

    private func bindViewModel() {
        viewModel.topImage
            .sink { [weak self] imageModel in
            guard let self else { return }
            self.viewModel.imagePublisher(for: imageModel)
                .receive(on: DispatchQueue.main)
                .sink { uiimage in self.photoImage.image = uiimage }
                .store(in: &self.disposalBag)
            }
            .store(in: &disposalBag)

        header.homeButton.addAction(
            UIAction { [weak self] _ in self?.viewModel.returnToHomeScreen() },
            for: .touchUpInside
        )
    }

    private func configure() {
        backgroundColor = .systemGray5
        relatedLabel.text = "Related"
    }

    private func setConstraints() {
        addSubviews(
            header,
            photoImage,
            zoomButton,
            photoInfoBlock,
            relatedLabel,
            relatedCollection
        )

        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(140)
        }

        photoImage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(header.snp.bottom).inset(-10)
            make.height.lessThanOrEqualTo(220)
        }

        photoInfoBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(187)
            make.top.equalTo(photoImage.snp.bottom)
        }

        relatedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(photoInfoBlock.snp.bottom).inset(-16)
            make.width.equalTo(64)
            make.height.equalTo(22)
        }

        relatedCollection.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(relatedLabel.snp.bottom).inset(-16)
        }
    }
}


class PhotoScreenViewModel: ViewModel, DataProvider {
    struct Dependencies {
        let networkManager: NetworkManager
        let topImage: ISImage
        let related: [ISImage]
        let goHome: () -> Void
    }

    let images: CurrentValueSubject<[ISImage], Never>
    let topImage: CurrentValueSubject<ISImage, Never>
    let goHome: () -> Void

    private let networkManager: NetworkManager
    private var imageDownloadSubscription: AnyCancellable?

    init(dependencies: Dependencies) {
        topImage = .init(dependencies.topImage)
        images = .init(dependencies.related)
        networkManager = dependencies.networkManager
        goHome = dependencies.goHome
    }

    func returnToHomeScreen() {
        imageDownloadSubscription?.cancel()
        goHome()
    }

    func openPhotoScreen(path: IndexPath) {
        let newTopImage = images.value[path.item]
        imageDownloadSubscription = networkManager.getImages(
            query: newTopImage.formattedTags.first ?? "", page: 1, userPreferences: .init()
        )
            .sink { [weak self] result in
                switch result {
                case .success(let response): self?.images.send(response.hits)
                case .failure(let error): print(error)
                }
            }
        topImage.send(newTopImage)
    }

    func imagePublisher(for model: ISImage) -> AnyPublisher<UIImage, Never> {
        return networkManager.downloadImage(from: model.largeImageURL)
    }
}
