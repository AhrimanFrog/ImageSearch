import UIKit
import Photos

class LocalImagesCollection: UICollectionView {
    private let dataProvider: LocalPhotosViewModel
    private var assets: PHFetchResult<PHAsset>

    init(dataProvider: LocalPhotosViewModel) {
        self.dataProvider = dataProvider
        assets = dataProvider.fetchAssets()
        super.init(frame: .zero, collectionViewLayout: .mediaLayout(padding: 12))
        register(LocaleImageCell.self)
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocalImagesCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let collectionWidth = collectionView.frame.width
        let horizontalPadding = layout?.sectionInset.horizontal ?? 0
        let interitemSpacing = layout?.minimumInteritemSpacing ?? 0
        let itemsPerRow: CGFloat = 2
        let width = (collectionWidth - horizontalPadding - interitemSpacing * (itemsPerRow - 1)) / itemsPerRow
        return .init(width: width, height: width * 0.6)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assets.object(at: indexPath.item)
        dataProvider.requestImage(for: asset, ofSize: PHImageManagerMaximumSize) { [weak self] in
            self?.dataProvider.openCropScreen?($0)
        }
    }
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
