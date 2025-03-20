import CropViewController
import UIKit
import Photos

class ImageCropScreen: CropViewController {
    private var croppedImage: UIImage?
    private let library: PHPhotoLibrary

    init(image: UIImage, library: PHPhotoLibrary) {
        self.library = library
        super.init(image: image)
        delegate = self
    }

    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCropScreen: CropViewControllerDelegate {
    func cropViewController(_: CropViewController, didCropToImage image: UIImage, withRect: CGRect, angle: Int) {
        library.performChanges(
            { PHAssetChangeRequest.creationRequestForAsset(from: image) },
            completionHandler: { [weak self] success, error in
                guard !success, let error else {
                    DispatchQueue.main.async { self?.dismiss(animated: true) }
                    return
                }
                print(error.localizedDescription)
            }
        )
    }
}
