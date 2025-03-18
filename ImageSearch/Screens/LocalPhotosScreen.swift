import UIKit
import SnapKit
import Photos

class LocalPhotosScreen: ISScreen<LocalPhotosViewModel> {
    private let collectionView = UICollectionView()

    override init(viewModel: LocalPhotosViewModel) {
        super.init(viewModel: viewModel)
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
}

class LocalPhotosViewModel: ViewModel  {
    private let imageManager: PHImageManager // maybe better if changed to protocol

    init(imageManager: PHImageManager = .default()) {
        self.imageManager = imageManager
    }

    func fetchAssets() -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: .image, options: nil)
    }
}
