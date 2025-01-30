import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubviews($0) }
    }
}
