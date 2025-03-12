import UIKit

extension UICollectionViewLayout {
    static func mediaLayout() -> UICollectionViewFlowLayout {
        let padding: CGFloat = 16
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(all: padding)
        return layout
    }
}
