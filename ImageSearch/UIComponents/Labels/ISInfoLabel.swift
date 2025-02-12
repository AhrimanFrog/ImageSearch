import UIKit

class ISInfoLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .openSans(ofSize: 18, style: .medium)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
