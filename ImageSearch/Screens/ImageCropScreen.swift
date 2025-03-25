import CropViewController
import UIKit
import Photos

class ImageCropScreen: CropViewController {
    private var croppedImage: UIImage?
    private let library: PHPhotoLibrary
    private let errorHandler: (String) -> Void

    init(image: UIImage, library: PHPhotoLibrary, errorHandler: @escaping (String) -> Void) {
        self.library = library
        self.errorHandler = errorHandler
        super.init(image: image)
        onDidCropToRect = saveToLibrary
    }

    @MainActor
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func saveToLibrary(_ image: UIImage, _: CGRect, _: Int) {
        library.saveImage(image) { [weak self] success, error in
            guard !success, let error else {
                DispatchQueue.main.async { self?.dismiss(animated: true) }
                return
            }
            self?.errorHandler(error.localizedDescription)
        }
    }
}
