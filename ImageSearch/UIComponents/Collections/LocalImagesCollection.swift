import UIKit
import Photos

class LocalImagesCollection: UICollectionView {
    private let dataProvider: LocalPhotosViewModel
    private var assets: PHFetchResult<PHAsset>
    
    init(dataProvider: LocalPhotosViewModel) {
        self.dataProvider = dataProvider
        assets = dataProvider.fetchAssets()
        super.init(frame: .zero, collectionViewLayout: .mediaLayout())
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
