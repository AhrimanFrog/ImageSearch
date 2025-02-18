import UIKit
import Combine

class ISVerticalCollectionView: UICollectionView {
    private var dataProvider: SearchResultsViewModel
    private var diffDataSource: UICollectionViewDiffableDataSource<String, ISImage>?
    private var dataSubscription: AnyCancellable?

    init(dataProvider: SearchResultsViewModel, layout: UICollectionViewLayout) {
        self.dataProvider = dataProvider
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .systemGray5

        register(ISMediaCell.self)
        configureDataSource(with: dataProvider)
        delegate = self
        dataSubscription = dataProvider.images.sink { [weak self] in self?.updateUI(with: $0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureDataSource(with viewModel: SearchResultsViewModel) {
        diffDataSource = .init(collectionView: self) { [weak viewModel] collection, indexPath, image in
            return collection.deque(ISMediaCell.self, for: indexPath) { cell in
                cell.subscribe(to: viewModel?.imagePublisher(for: image))
            }
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

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataProvider.openPhotoScreen(path: indexPath)
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
