import UIKit
import Photos

class LocalScreenFactory {
    private let library = PHPhotoLibrary.shared()
    private let imageManager = PHImageManager.default()
    
    weak var navigationHandler: LocalSearchCoordinator?

    func build(screen: LocalSearchCoordinator.Destination) -> UIViewController {
        switch screen {
        case .localPhotos:
            let viewModel = LocalPhotosViewModel(imageManager: imageManager) {[weak self] image in
                self?.navigationHandler?.navigate(to: .transformation(image))
            }
            return HostingController(contentView: LocalPhotosScreen(viewModel: viewModel))
        case .transformation(let image):
            return ImageCropScreen(image: image, library: library)
        }
    }
}
