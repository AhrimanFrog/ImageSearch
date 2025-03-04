import UIKit

extension UIImage {
    enum SFImage: String {
        case zoomIn = "plus.magnifyingglass"
        case zoomOut = "minus.magnifyingglass"
        case search = "magnifyingglass"
        case checkmark = "checkmark.seal.fill"
        case close = "xmark.circle"
        case down = "chevron.down"
    }

    convenience init?(sfImage: SFImage) {
        self.init(systemName: sfImage.rawValue)
    }
}
