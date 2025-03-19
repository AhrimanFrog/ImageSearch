import UIKit
import SnapKit
import Photos

class LocalPhotosScreen: ISScreen<LocalPhotosViewModel> {
    private let collectionView: LocalImagesCollection

    override init(viewModel: LocalPhotosViewModel) {
        self.collectionView = .init(dataProvider: viewModel)
        super.init(viewModel: viewModel)
        configure()
    }

    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            switch status {
            case .notDetermined, .denied, .restricted: self?.showEmptyView()
            case .limited, .authorized: self?.showUserPhotos()
            default: self?.showEmptyView()
            }
        }
    }

    private func showEmptyView() {
    }

    private func showUserPhotos() {
    }

    private func configure() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
    }
}

class LocalPhotosViewModel: ViewModel {
    private let imageManager: PHImageManager // maybe better if changed to protocol

    init(imageManager: PHImageManager = .default()) {
        self.imageManager = imageManager
    }

    func fetchAssets() -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: .image, options: nil)
    }

    func requestImage(for asset: PHAsset, ofSize: CGSize, handler: @escaping (UIImage) -> Void) -> PHImageRequestID {
        imageManager.requestImage(for: asset, targetSize: ofSize, contentMode: .aspectFit, options: nil) { image, _ in
            handler(image ?? .notFound)
        }
    }

    func cancelRequest(_ code: PHImageRequestID) {
        imageManager.cancelImageRequest(code)
    }
}
