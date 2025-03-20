import UIKit
import SnapKit
import Photos

class LocaleImageCell: UICollectionViewCell, ReuseIdentifiable {
    private let imageView = UIImageView()

    var code: PHImageRequestID?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
    }

    private func configure() {
        imageView.image = .notFound
        addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
