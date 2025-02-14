import UIKit
import Combine

class ISHorizontalCollectionView: UICollectionView {
    private let viewModel: SearchResultsViewModel
    private var dataProvider: UICollectionViewDiffableDataSource<String, String>?
    private var dataSubscription: AnyCancellable?

    init(viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .systemGray5
        delegate = self
        register(ISSuggestionCell.self)
        configureDataProvider()
        dataSubscription = viewModel.related.sink { [weak self] in self?.applySnapshot(of: $0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureDataProvider() {
        dataProvider = .init(collectionView: self) { collectionView, indexPath, text in
            return collectionView.deque(ISSuggestionCell.self, for: indexPath) { cell in
                cell.setText(text)
            }
        }
    }

    private func applySnapshot(of data: Set<String>) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(Array(data))
        DispatchQueue.main.async { self.dataProvider?.apply(snapshot) }
    }
}

extension ISHorizontalCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ISSuggestionCell else { return }
        viewModel.transitToResults(of: cell.text)
    }
}
