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
        configuration = .filled()
        configuration?.baseBackgroundColor = .init(red: 0.261, green: 0.044, blue: 0.879, alpha: 1)
        configuration?.baseForegroundColor = .white
        configuration?.title = title
        configuration?.image = UIImage(sfImage: image)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}
