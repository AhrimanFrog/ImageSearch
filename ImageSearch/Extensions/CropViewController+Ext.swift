import CropViewController
import Photos

extension CropViewController {
    func addImageSaver(library: PHPhotoLibrary, resultHandler: @escaping (Result<Void, Error>) -> Void) {
        onDidCropToRect = { croppedImage, _, _ in
            library.saveImage(croppedImage) { success, error in
                guard !success, let error else { return resultHandler(.success(())) }
                return resultHandler(.failure(error))
            }
        }
    }
}
