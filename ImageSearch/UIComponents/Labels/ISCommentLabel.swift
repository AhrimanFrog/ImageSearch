import UIKit

class ISCommentLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .openSans(ofSize: 14, style: .light)
        textColor = .systemGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
