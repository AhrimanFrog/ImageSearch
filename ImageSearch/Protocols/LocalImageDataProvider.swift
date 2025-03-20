import UIKit
import Photos

protocol LocalImageDataProvider {
    var openCropScreen: ((UIImage) -> Void)? { get }

    func requestImage(for asset: PHAsset, ofSize: CGSize, handler: @escaping (UIImage) -> Void) -> PHImageRequestID
    func cancelRequest(_ code: PHImageRequestID)
}
