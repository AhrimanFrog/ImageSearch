import UIKit

class ISButton: UIButton {
    enum Style {
        case filled, plain
    }

    init(title: String, image: UIImage.SFImage, style: Style = .filled) {
        super.init(frame: .zero)
        configure(title: title, image: image, style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(title: String, image: UIImage.SFImage, style: Style) {
        var config = switch style {
        case .filled: filled()
        case .plain: plain()
        }
        config.title = title
        config.image = UIImage(sfImage: image)
        config.imagePadding = 6
        config.imagePlacement = .leading
        configuration = config
    }

    private func filled() -> Configuration {
        var config = Configuration.filled()
        config.baseBackgroundColor = .customPurple
        config.baseForegroundColor = .white
        return config
    }

    private func plain() -> Configuration {
        var config = Configuration.plain()
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = .label
        layer.cornerRadius = 5
        layer.borderColor = UIColor.purple.cgColor
        layer.borderWidth = 1
        return config
    }
}
