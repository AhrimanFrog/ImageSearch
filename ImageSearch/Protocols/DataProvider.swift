import Combine
import Foundation
import UIKit

protocol DataProvider: AnyObject {
    func fetchMoreResults()
    func openPhotoScreen(forPhoto: ISImage)
    func imagePublisher(for: ISImage) -> AnyPublisher<UIImage, Never>
    var images: CurrentValueSubject<[ISImage], Never> { get }
    var share: (UIImage, String) -> Void { get }
}


extension DataProvider {
    func fetchMoreResults() {}
}
