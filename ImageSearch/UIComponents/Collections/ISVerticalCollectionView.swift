import UIKit
import Combine

class ISVerticalCollectionView<CELL: ISMediaCell>:
    UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    private var dataProvider: DataProvider
    private var diffDataSource: UICollectionViewDiffableDataSource<String, ISImage>?
    private var dataSubscription: AnyCancellable?
    private let cellType: CELL.Type

    init(dataProvider: DataProvider, layout: UICollectionViewLayout, cell: CELL.Type) {
        self.dataProvider = dataProvider
        cellType = cell
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .systemGray5

        register(cellType)
        configureDataSource(with: dataProvider)
        delegate = self
        dataSubscription = dataProvider.images.sink { [weak self] in self?.updateUI(with: $0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureDataSource(with viewModel: DataProvider) {
        diffDataSource = .init(collectionView: self) { [weak viewModel, cellType] collection, indexPath, image in
            return collection.deque(cellType, for: indexPath) { cell in
                cell.subscribe(to: viewModel?.imagePublisher(for: image))
                guard let sharedCell = cell as? ISSharedCell else { return }
                sharedCell.addSource(image.largeImageURL)
            }
        }
    }

    private func updateUI(with images: [ISImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, ISImage>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(images, toSection: "main")
        DispatchQueue.main.async { self.diffDataSource?.apply(snapshot) }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {  // delegate method
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let viewHeight = scrollView.frame.size.height

        guard offsetY > (contentHeight - viewHeight) else { return }
        dataProvider.fetchMoreResults()
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) { // delegate method
        dataProvider.openPhotoScreen(path: indexPath)
        setContentOffset(.zero, animated: true)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize { // flow layout delegate
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let collectionWidth = collectionView.frame.width
        let horizontalPadding = layout?.sectionInset.horizontal ?? 0
        let interitemSpacing = layout?.minimumInteritemSpacing ?? 0
        let itemsPerRow: CGFloat = collectionWidth > collectionView.frame.height ? 2 : 1
        let width = (collectionWidth - horizontalPadding - interitemSpacing * (itemsPerRow - 1)) / itemsPerRow

        return .init(width: width, height: width * 0.6)
    }
}
