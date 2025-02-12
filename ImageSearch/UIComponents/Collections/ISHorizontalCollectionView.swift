import UIKit

class ISHorizontalCollectionView: UICollectionView {
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8

        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .systemGray5
        register(ISSuggestionCell.self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

