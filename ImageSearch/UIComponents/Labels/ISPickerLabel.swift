import UIKit
import SnapKit

class ISPickerLabel: ISSettingLabel {
    private let image = UIImageView(image: .init(sfImage: .picker))

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        image.tintColor = .customPurple
        image.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(10)
            make.width.equalTo(12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
