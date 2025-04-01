import UIKit

extension UIImage {
    enum SFImage: String {
        case zoomIn = "plus.magnifyingglass"
        case zoomOut = "minus.magnifyingglass"
        case search = "magnifyingglass"
        case checkmark = "checkmark.seal.fill"
        case save = "checkmark.circle"
        case close = "xmark.circle"
        case down = "chevron.down"
        case picker = "chevron.up.chevron.down"
        case change = "crop.rotate"
        case photoAccessDenied = "eye.slash"
        case settings = "gearshape"
        case crop = "crop"
    }

    convenience init?(sfImage: SFImage) {
        self.init(systemName: sfImage.rawValue)
    }
}
