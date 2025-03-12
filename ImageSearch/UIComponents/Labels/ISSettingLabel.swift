import UIKit

class ISSettingLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .openSans(ofSize: 18, style: .bold)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
