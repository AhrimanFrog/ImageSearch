import UIKit
import Combine

class ISVerticalCollectionView: UICollectionView {
    private let dataProvider: SearchResultsViewModel // TODO: swap for protocol

    init(dataProvider: SearchResultsViewModel, layout: UICollectionViewLayout) {
        self.dataProvider = dataProvider
        super.init(frame: .zero, collectionViewLayout: layout)
        register(ISMediaCell.self)
        dataSource = self
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
}
