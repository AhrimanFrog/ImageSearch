import UIKit
import Photos
import Combine

class LocalImagesCollection: UICollectionView {
    private let dataProvider: LocalImageDataProvider
    let assets = CurrentValueSubject<PHFetchResult<PHAsset>, Never>(.init())
    
    private var dataSubscriptions = Set<AnyCancellable>()

    init(dataProvider: (some LocalImageDataProvider)) {
        self.dataProvider = dataProvider
        super.init(frame: .zero, collectionViewLayout: .mediaLayout(padding: 12))
        register(LocalImageCell.self)
        dataSource = self
        delegate = self
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        assets.sink { [weak self] _ in self?.reloadData() }.store(in: &dataSubscriptions)
        dataProvider.libraryChangesPublisher
            .sink { change in
                print(change)
            }
            .store(in: &dataSubscriptions)
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
        let asset = assets.value.object(at: indexPath.item)
        dataProvider.requestImage(for: asset, ofSize: PHImageManagerMaximumSize) { [weak self] in
            self?.dataProvider.openCropScreen?($0)
        }
    }
}

extension LocalImagesCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.value.count
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return collectionView.deque(LocalImageCell.self, for: indexPath) { [weak self] cell in
            guard let self else { return }
            let code = dataProvider.requestImage(
                for: assets.value.object(at: indexPath.item),
                ofSize: cell.frame.size
            ) { cell.setImage($0) }
            cell.cancelImageRequest = { [weak self] in self?.dataProvider.cancelRequest(code) }
        }
    }
}
