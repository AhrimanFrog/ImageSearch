import CropViewController
import UIKit
import Photos

class ImageCropScreen: CropViewController {
    private var croppedImage: UIImage?
    private let library: PHPhotoLibrary
    private let errorHandler: (String) -> Void
    private var saveAllowed = false

    init(image: UIImage, library: PHPhotoLibrary, errorHandler: @escaping (String) -> Void) {
        self.library = library
        self.errorHandler = errorHandler
        super.init(image: image)
        delegate = self
    }

    @MainActor
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCropScreen: CropViewControllerDelegate {
    func cropViewController(_: CropViewController, didCropToImage image: UIImage, withRect: CGRect, angle: Int) {
        saveAllowed.toggle() // because of library bug when delegate method is called twice
        guard saveAllowed else { return }
        library.performChanges(
            { PHAssetChangeRequest.creationRequestForAsset(from: image) },
            completionHandler: { [weak self] success, error in
                guard !success, let error else {
                    DispatchQueue.main.async { self?.dismiss(animated: true) }
                    return
                }
                self?.errorHandler(error.localizedDescription)
            }
        )
    }
}
