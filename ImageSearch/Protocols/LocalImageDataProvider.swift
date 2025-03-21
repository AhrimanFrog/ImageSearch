import UIKit
import Photos
import Combine

protocol LocalImageDataProvider {
    var openCropScreen: ((UIImage) -> Void)? { get }
    var libraryChangesPublisher: PassthroughSubject<PHChange, Never> { get }

    @discardableResult
    func requestImage(for asset: PHAsset, ofSize: CGSize, handler: @escaping (UIImage) -> Void) -> PHImageRequestID
    func cancelRequest(_ code: PHImageRequestID)
}
