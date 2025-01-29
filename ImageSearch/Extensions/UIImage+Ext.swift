import UIKit

extension UIImage {
    enum SFImage: String {
        case settings = "slider.horizontal.3"
        case zoomIn = "plus.magnifyingglass"
        case zoomOut = "minus.magnifyingglass"
        case download = "arrow.down.to.line.compact"
        case search = "magnifyingglass"
    }

    convenience init?(sfImage: SFImage) {
        self.init(systemName: sfImage.rawValue)
    }
}
