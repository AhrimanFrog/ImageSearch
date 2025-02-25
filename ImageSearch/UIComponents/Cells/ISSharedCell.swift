import UIKit
import SnapKit

class ISSharedCell: ISMediaCell {
    private let shareButton = UIButton()

    var image: UIImage { imageView.image ?? .notFound }

    override func configure() {
        super.configure()
        addSubview(shareButton)
        registerForTraitChanges([UITraitActiveAppearance.self], action: #selector(setColor))
        setColor()
        shareButton.setImage(UIImage(resource: .share), for: .normal)
        shareButton.addAction(
            UIAction { [weak self] _ in
                guard let self, let source = imageSource?.largeImageURL else { return }
                touchHandler?(.share(image, source))
            },
            for: .touchUpInside
        )
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
