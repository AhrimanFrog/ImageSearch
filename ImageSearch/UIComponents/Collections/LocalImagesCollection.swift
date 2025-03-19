import UIKit
import Photos

class LocalImagesCollection: UICollectionView {
    private let dataProvider: LocalPhotosViewModel
    private var assets: PHFetchResult<PHAsset>

    init(dataProvider: LocalPhotosViewModel) {
        self.dataProvider = dataProvider
        assets = dataProvider.fetchAssets()
        super.init(frame: .zero, collectionViewLayout: .mediaLayout())
        register(LocaleImageCell.self)
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocalImagesCollection: UICollectionViewDelegate {
}

extension LocalImagesCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return collectionView.deque(LocaleImageCell.self, for: indexPath) { [weak self] cell in
            guard let self else { return }
            if let code = cell.code { dataProvider.cancelRequest(code) }
            cell.code = dataProvider.requestImage(
                for: assets.object(at: indexPath.item),
                ofSize: cell.frame.size
            ) { cell.setImage($0) }
        }
    }
}
