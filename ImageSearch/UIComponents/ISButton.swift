import UIKit

class ISButton: UIButton {
    init(title: String, image: UIImage.SFImage) {
        super.init(frame: .zero)
        configure(title: title, image: image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(title: String, image: UIImage.SFImage) {
        var config = Configuration.filled()
        config.baseBackgroundColor = .init(red: 0.261, green: 0.044, blue: 0.879, alpha: 1)
        config.baseForegroundColor = .white
        config.title = title
        config.image = UIImage(sfImage: image)
        config.imagePadding = 6
        config.imagePlacement = .leading
        configuration = config
    }
}
