import UIKit

class ISButton: UIButton {
    enum Style {
        case filled, plain
    }

    init(title: String, image: UIImage?, style: Style = .filled) {
        super.init(frame: .zero)
        configure(title: title, image: image, style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(title: String, image: UIImage?, style: Style) {
        var config = switch style {
        case .filled: filled(title)
        case .plain: plain(title)
        }
        config.image = image
        config.imagePadding = 6
        config.imagePlacement = .leading
        configuration = config
    }

    private func filled(_ title: String) -> Configuration {
        var config = Configuration.filled()
        config.baseBackgroundColor = .customPurple
        config.baseForegroundColor = .white
        config.attributedTitle = .init(title, attributes: .init([.font: UIFont.openSans(ofSize: 18, style: .bold)!]))
        return config
    }

    private func plain(_ title: String) -> Configuration {
        var config = Configuration.plain()
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = .label
        config.attributedTitle = .init(title, attributes: .init([.font: UIFont.openSans(ofSize: 14, style: .light)!]))
        layer.cornerRadius = 5
        layer.borderColor = UIColor.customPurple.cgColor
        layer.borderWidth = 1
        return config
    }
}
