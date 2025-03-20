import Combine
import Foundation
import UIKit

protocol NetworkDataProvider: AnyObject {
    func fetchMoreResults()
    func openPhotoScreen(forPhoto: ISImage)
    func imagePublisher(for: ISImage) -> AnyPublisher<UIImage, Never>
    var images: CurrentValueSubject<[ISImage], Never> { get }
    var share: (UIImage, String) -> Void { get }
}


extension NetworkDataProvider {
    func fetchMoreResults() {}
}
