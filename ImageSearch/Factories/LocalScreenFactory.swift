import UIKit
import Photos
import CropViewController

class LocalScreenFactory {
    private let library = PHPhotoLibrary.shared()
    private let imageManager = PHImageManager.default()

    weak var navigationHandler: LocalSearchCoordinator?

    func build(screen: LocalSearchCoordinator.Destination) -> UIViewController {
        switch screen {
        case .localPhotos:
            let viewModel = LocalPhotosViewModel(imageManager: imageManager) { [weak self] image in
                self?.navigationHandler?.navigate(to: .transformation(image))
            }
            library.register(viewModel)
            return HostingController(contentView: LocalPhotosScreen(viewModel: viewModel))
        case .transformation(let image):
            let cropController = CropViewController(image: image)
            cropController.addImageSaver(library: library) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.navigationHandler?.mainController.dismiss(animated: true)
                    case .failure(let error):
                        self?.navigationHandler?.handleError(with: error.localizedDescription)
                    }
                }
            }
            return cropController
        }
    }
}
