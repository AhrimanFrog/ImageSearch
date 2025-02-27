import UIKit

extension UIImage {
    enum SFImage: String {
        case zoomIn = "plus.magnifyingglass"
        case zoomOut = "minus.magnifyingglass"
        case search = "magnifyingglass"
        case checkmark = "checkmark.seal.fill"
        case close = "xmark.circle"
    }

    convenience init?(sfImage: SFImage) {
        self.init(systemName: sfImage.rawValue)
    }
}
