import UIKit

extension UICollectionViewLayout {
    static func mediaLayout(padding: CGFloat = 16) -> UICollectionViewFlowLayout {
        let padding: CGFloat = padding
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(all: padding)
        return layout
    }
}
