import UIKit

extension UIFont {
    enum FontStyle: String {
        case bold, light, medium, regular
    }

    static func openSans(ofSize: CGFloat, style: FontStyle = .regular) -> UIFont? {
        return UIFont(name: "OpenSans-\(style.rawValue.capitalized)", size: ofSize)
    }
}
