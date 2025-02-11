import UIKit

extension UICollectionViewLayout {
    static func mediaLayout(in view: UIView, itemsNumber: Int) -> UICollectionViewFlowLayout {
        let padding: CGFloat = 16
        let availableWidth = view.bounds.width - padding * 2
        let itemWidth = availableWidth / CGFloat(itemsNumber)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth - 100)

        return layout
    }
}
