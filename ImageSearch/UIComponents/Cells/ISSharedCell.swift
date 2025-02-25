import UIKit
import SnapKit

class ISSharedCell: ISMediaCell {
    private let shareButton = UIButton()
    private(set) var imageSource: ISImage?

    var image: UIImage { imageView.image ?? .notFound }

    func addSource(_ source: ISImage) {
        imageSource = source
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageSource = nil
    }

    override func configure() {
        super.configure()
        addSubview(shareButton)
        registerForTraitChanges([UITraitActiveAppearance.self], action: #selector(setColor))
        setColor()
        shareButton.setImage(UIImage(resource: .share), for: .normal)
        shareButton.layer.cornerRadius = 5.0
        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.trailing.top.equalToSuperview().inset(20)
        }
    }

    @objc private func setColor() {
        shareButton.layer.backgroundColor = UIColor.systemGray3.cgColor
    }
}
