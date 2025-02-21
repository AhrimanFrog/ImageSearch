import Combine
import Foundation
import UIKit

protocol DataProvider: AnyObject {
    func fetchMoreResults()
    func openPhotoScreen(path: IndexPath)
    func imagePublisher(for: ISImage) -> AnyPublisher<UIImage, Never>
    var images: CurrentValueSubject<[ISImage], Never> { get }
}


extension DataProvider {
    func fetchMoreResults() {}
}
