import UIKit
import SnapKit

class ISMediaCell: UICollectionViewCell, ReuseIdentifiable {
    private let imageView = UIImageView()
    private let shareButton = UIButton()

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
        addSubviews(imageView, shareButton)
        shareButton.setBackgroundImage(UIImage(resource: .share), for: .normal)

        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        shareButton.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(32)
            make.leading.top.equalToSuperview().inset(20)
        }
    }
}
