import UIKit
import SnapKit
import Photos
import CropViewController
import Combine

class LocalPhotosScreen: ISScreen<LocalPhotosViewModel> {
    private let collectionView: LocalImagesCollection
    private var authorizationStatusSubscrioption: AnyCancellable?
    private let accessDeniedView = AccessDeniedView()

    override init(viewModel: LocalPhotosViewModel) {
        self.collectionView = .init(dataProvider: viewModel)
        super.init(viewModel: viewModel)
        configure()
        authorizationStatusSubscrioption = getStatusSubscription()
    }

    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationStatusDidChange(PHPhotoLibrary.authorizationStatus(for: .readWrite))
    }

    private func getStatusSubscription() -> AnyCancellable {
        return viewModel.$librabryAccessStatus
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] in self?.authorizationStatusDidChange($0) }
    }

    private func authorizationStatusDidChange(_ status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined: PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] in
            self?.viewModel.librabryAccessStatus = $0
        }
        case .denied, .restricted: showAccessDeniedView()
        case .limited, .authorized: showUserPhotos()
        default: showAccessDeniedView()
        }
    }

    private func showAccessDeniedView() {
        accessDeniedView.isHidden = false
    }

    private func showUserPhotos() {
        accessDeniedView.isHidden = true
        collectionView.assets.send(viewModel.fetchAssets())
    }

    private func configure() {
        addSubviews(collectionView, accessDeniedView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
        accessDeniedView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
    }
}

class LocalPhotosViewModel: NSObject, ViewModel, LocalImageDataProvider {
    let libraryChangesPublisher = PassthroughSubject<PHChange, Never>()
    var openCropScreen: ((UIImage) -> Void)?
    @Published var librabryAccessStatus: PHAuthorizationStatus = .denied

    private let imageManager: PHImageManager // maybe better if changed to protocol

    init(imageManager: PHImageManager, openCropScreen: @escaping (UIImage) -> Void) {
        self.imageManager = imageManager
        self.openCropScreen = openCropScreen
        super.init()
    }

    func fetchAssets() -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: .image, options: nil)
    }

    @discardableResult
    func requestImage(for asset: PHAsset, ofSize: CGSize, handler: @escaping (UIImage) -> Void) -> PHImageRequestID {
        imageManager.requestImage(for: asset, targetSize: ofSize, contentMode: .aspectFit, options: nil) { image, _ in
            handler(image ?? .notFound)
        }
    }

    func cancelRequest(_ code: PHImageRequestID) {
        imageManager.cancelImageRequest(code)
    }
}

extension LocalPhotosViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        librabryAccessStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        libraryChangesPublisher.send(changeInstance)
    }
}
