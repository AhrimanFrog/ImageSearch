import UIKit
import SnapKit
import Photos

class LocalImageCell: UICollectionViewCell, ReuseIdentifiable {
    private let imageView = UIImageView()

    var code: PHImageRequestID?
    var cancelImageRequest: (() -> Void)?

    var image: UIImage? { imageView.image }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageRequest?()
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
