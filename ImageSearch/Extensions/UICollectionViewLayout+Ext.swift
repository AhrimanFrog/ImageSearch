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

extension UIEdgeInsets {
    var horizontal: CGFloat { left + right }

    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }
}
