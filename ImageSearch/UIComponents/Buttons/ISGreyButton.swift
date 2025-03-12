import UIKit

class ISGreyButton: UIButton {
    init(image: UIImage?) {
        super.init(frame: .zero)
        registerForTraitChanges([UITraitActiveAppearance.self], action: #selector(setColor))
        setColor()
        setImage(image, for: .normal)
        imageView?.tintColor = .customPurple
        layer.cornerRadius = 5.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func setColor() {
        layer.backgroundColor = UIColor.systemGray3.cgColor
    }
}
