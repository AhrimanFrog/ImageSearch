import UIKit

class ISTitleLabel: UILabel {
    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        text = String(localized: "title_label")
        lineBreakMode = .byTruncatingTail
        numberOfLines = 3
        textColor = .white
        textAlignment = .center
        font = .openSans(ofSize: 34, style: .bold)
    }
}
