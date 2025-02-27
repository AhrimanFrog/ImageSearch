import UIKit
import Combine

class ISVerticalCollectionView: UICollectionView {
    private var dataProvider: DataProvider
    private var diffDataSource: UICollectionViewDiffableDataSource<String, ISImage>?
    private var dataSubscription: AnyCancellable?

    convenience init(
        dataProvider: DataProvider,
        layout: UICollectionViewLayout,
        cellType: (some ISMediaCell).Type
    ) {
        self.init(dataProvider: dataProvider, layout: layout)
        register(cellType)

        diffDataSource = .init(collectionView: self) { [dataProvider] collection, indexPath, image in
            return collection.deque(cellType, for: indexPath) { cell in
                cell.subscribe(to: dataProvider.imagePublisher(for: image))
                cell.addTouchHandler { [weak self] touch in self?.handleCellTouch(touch) }
                cell.addSource(image)
            }
        }
    }

    init(dataProvider: DataProvider, layout: UICollectionViewLayout) {
        self.dataProvider = dataProvider
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .systemGray5
        delegate = self
        dataSubscription = dataProvider.images.sink { [weak self] in self?.updateUI(with: $0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func handleCellTouch(_ touch: ISMediaCell.Touch) {
        switch touch {
        case let .photo(photo): dataProvider.openPhotoScreen(forPhoto: photo)
        case let .share(image, source): dataProvider.share(image, source)
        }
    }

    private func updateUI(with images: [ISImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, ISImage>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(images, toSection: "main")
        DispatchQueue.main.async { self.diffDataSource?.apply(snapshot) }
    }
}

extension ISVerticalCollectionView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let viewHeight = scrollView.frame.size.height

        guard offsetY > (contentHeight - viewHeight) else { return }
        dataProvider.fetchMoreResults()
    }
}

extension ISVerticalCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let collectionWidth = collectionView.frame.width
        let horizontalPadding = layout?.sectionInset.horizontal ?? 0
        let interitemSpacing = layout?.minimumInteritemSpacing ?? 0
        let itemsPerRow: CGFloat = collectionWidth > collectionView.frame.height ? 2 : 1
        let width = (collectionWidth - horizontalPadding - interitemSpacing * (itemsPerRow - 1)) / itemsPerRow

        return .init(width: width, height: width * 0.6)
    }
}
