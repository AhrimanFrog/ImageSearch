import UIKit
import SnapKit
import Combine
import Hero
import Photos

class PhotoScreen: ISScreen<PhotoScreenViewModel> {
    private let topBanner = UIView()
    private let photoSavedView = SaveSuccessfulView()
    private let header = ISHeaderBlock()
    private let photoImage = UIImageView()
    private let zoomButton = ISGreyButton(image: UIImage(sfImage: .zoomIn))
    private let cropButton = ISGreyButton(image: UIImage(sfImage: .crop))
    private let photoInfoBlock = ISPhotoInfoBlock(frame: .zero)
    private let relatedLabel = ISInfoLabel()
    private let relatedCollection: ISVerticalCollectionView

    private var disposalBag = Set<AnyCancellable>()

    override init(viewModel: PhotoScreenViewModel) {
        relatedCollection = .init(dataProvider: viewModel, layout: .mediaLayout(), cellType: ISMediaCell.self)
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
            .flatMap { [weak self, viewModel] imageModel in
                self?.photoInfoBlock.setImageFormat(toFormatOf: imageModel)
                return viewModel.imagePublisher(for: imageModel).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newImage in self?.photoImage.image = newImage }
            .store(in: &disposalBag)

        header.homeButton.addAction(
            UIAction { [weak self] _ in self?.viewModel.returnToHomeScreen() },
            for: .touchUpInside
        )
        header.preferencesButton.addAction(
            UIAction { [weak self] _ in self?.viewModel.openPreferences() },
            for: .touchUpInside
        )
        header.searchField.addInputProcessor { [weak self] input in self?.viewModel.openResultsOfQuery(input) }

        photoInfoBlock.downloadButton.addAction(
            UIAction { [weak self] _ in
                guard let image = self?.photoImage.image else { return }
                self?.viewModel.library.saveImage(image) { success, error in
                    guard !success, let error else {
                        DispatchQueue.main.async { self?.animateSuccessfulSaving() }
                        return
                    }
                    self?.viewModel.navigationHandler(.failure(error))
                }
            },
            for: .touchUpInside
        )

        photoInfoBlock.shareButton.addAction(
            UIAction { [weak self] _ in self?.viewModel.shareImage(self?.photoImage.image) },
            for: .touchUpInside
        )

        zoomButton.addAction(
            UIAction { [weak self] _ in self?.viewModel.zoomPhoto(self?.photoImage.image) },
            for: .touchUpInside
        )

        cropButton.addAction(
            UIAction { [weak self] _ in
                guard let image = self?.photoImage.image else { return }
                self?.viewModel.cropImage(image)
            },
            for: .touchUpInside
        )
    }

    private func animateSuccessfulSaving() {
        photoSavedView.alpha = 1
        UIView.animate(withDuration: 4) { [weak self] in self?.photoSavedView.alpha = 0.0 }
    }

    private func configure() {
        backgroundColor = .systemGray5
        topBanner.backgroundColor = .systemBackground
        relatedLabel.text = String(localized: "related")
        photoImage.contentMode = .scaleAspectFit
        photoImage.heroID = "photo"
        photoSavedView.alpha = 0.0
    }

    private func setConstraints() {
        addSubviews(
            header,
            photoImage,
            zoomButton,
            cropButton,
            photoInfoBlock,
            relatedLabel,
            relatedCollection,
            photoSavedView,
            topBanner
        )

        header.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }

        topBanner.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(header.snp.top)
        }

        photoImage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(header.snp.bottom).inset(-10)
            make.height.lessThanOrEqualTo(220)
        }

        zoomButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.trailing.bottom.equalTo(photoImage).inset(20)
        }

        cropButton.snp.makeConstraints { make in
            make.width.height.trailing.equalTo(zoomButton)
            make.bottom.equalTo(zoomButton.snp.top).offset(-20)
        }

        photoInfoBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.lessThanOrEqualTo(187)
            make.top.equalTo(photoImage.snp.bottom)
        }

        relatedLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(photoInfoBlock.snp.bottom).inset(-16)
            make.height.equalTo(22)
        }

        relatedCollection.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(relatedLabel.snp.bottom).inset(-16)
        }

        photoSavedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(120)
        }
    }
}

class PhotoScreenViewModel: ViewModel, NetworkDataProvider {
    struct Dependencies {
        let networkManager: NetworkManager
        let preferences: CurrentValueSubject<Preferences, Never>
        let topImage: ISImage
        let related: [ISImage]
        let library: PHPhotoLibrary
        let navigationHandler: NavigationHandler
        let share: (UIImage, String) -> Void
    }

    let images: CurrentValueSubject<[ISImage], Never>
    let topImage: CurrentValueSubject<ISImage, Never>
    var share: (UIImage, String) -> Void { dependencies.share }
    var library: PHPhotoLibrary { dependencies.library }
    var navigationHandler: NavigationHandler { dependencies.navigationHandler }
    private let dependencies: Dependencies
    private var disposalBag = Set<AnyCancellable>()

    init(dependencies: Dependencies) {
        topImage = .init(dependencies.topImage)
        images = .init(dependencies.related)
        self.dependencies = dependencies
    }

    func returnToHomeScreen() {
        navigationHandler(.success(.start))
    }

    func openPhotoScreen(forPhoto photo: ISImage) {
        guard let tag = photo.formattedTags.first else { return }
        dependencies.networkManager.getImages(query: tag, page: 1, userPreferences: dependencies.preferences.value)
            .sink { [weak self] result in
                switch result {
                case .success(let response): self?.images.send(response.hits)
                case .failure(let error): self?.navigationHandler(.failure(error))
                }
            }
            .store(in: &disposalBag)
        topImage.send(photo)
    }

    func shareImage(_ image: UIImage?) {
        guard let unwrappedImage = image else { return }
        share(unwrappedImage, topImage.value.largeImageURL)
    }

    func imagePublisher(for model: ISImage) -> AnyPublisher<UIImage, Never> {
        return dependencies.networkManager.downloadImage(from: model.largeImageURL)
    }

    func openResultsOfQuery(_ query: String) {
        dependencies.networkManager
            .getImages(query: query, page: 1, userPreferences: dependencies.preferences.value)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let respponse): self?.navigationHandler(.success(.results(respponse, query)))
                case .failure(let error): self?.navigationHandler(.failure(error))
                }
            }
            .store(in: &disposalBag)
    }

    func zoomPhoto(_ photo: UIImage?) {
        navigationHandler(.success(.zoom(photo)))
    }

    func cropImage(_ image: UIImage) {
        navigationHandler(.success(.crop(image)))
    }

    func openPreferences() {
        navigationHandler(.success(.preferences))
    }
}
