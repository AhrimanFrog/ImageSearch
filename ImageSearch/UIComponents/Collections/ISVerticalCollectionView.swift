import UIKit
import Combine

class ISVerticalCollectionView: UICollectionView {
    private let dataProvider: SearchResultsViewModel // TODO: swap for protocol

    init(dataProvider: SearchResultsViewModel, layout: UICollectionViewLayout) {
        self.dataProvider = dataProvider
        super.init(frame: .zero, collectionViewLayout: layout)
        register(ISMediaCell.self)
        dataSource = self
        delegate = self
        backgroundColor = .systemGray5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ISVerticalCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.deque(ISMediaCell.self, for: indexPath) { [weak dataProvider] cell in
            dataProvider?.provideImage(for: cell, at: indexPath)
        }
    }
}

extension ISVerticalCollectionView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print()
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
