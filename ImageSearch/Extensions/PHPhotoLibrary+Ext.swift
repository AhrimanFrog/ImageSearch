import UIKit
import Photos

extension PHPhotoLibrary {
    func saveImage(_ image: UIImage, _ completionHandler: @escaping (Bool, (any Error)?) -> Void) {
        performChanges(
            { PHAssetChangeRequest.creationRequestForAsset(from: image) },
            completionHandler: completionHandler
        )
    }
}
