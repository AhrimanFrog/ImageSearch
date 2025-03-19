import UIKit
import SnapKit
import Photos

class LocaleImageCell: UICollectionViewCell, ReuseIdentifiable {
    private let imageView = UIImageView()

    var code: PHImageRequestID?

    func setImage(_ image: UIImage) {
        imageView.image = image
    }

    private func configure() {
        imageView.image = .notFound
        addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
