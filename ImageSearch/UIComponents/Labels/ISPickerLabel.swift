import UIKit
import SnapKit

class ISPickerLabel: UIButton {
    let label = ISSettingLabel(frame: .zero)
    let stateLabel = UILabel()
    private let image = UIImageView(image: .init(sfImage: .picker))

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(image, stateLabel, label)
        image.tintColor = .customPurple
        stateLabel.font = .openSans(ofSize: 18, style: .light)
        stateLabel.textAlignment = .right

        label.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(snp.centerX)
        }
        image.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(10)
            make.width.equalTo(12)
        }
        stateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(label.snp.trailing).inset(12)
            make.trailing.equalTo(image.snp.leading).inset(-12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
