import UIKit
import SnapKit

class ISSettingsHeaderBlock: UIView {
    let closeButton = ISGreyButton(image: .init(sfImage: .close))
    let doneButton = ISGreyButton(image: .init(sfImage: .save))
    private let titleLabel = UILabel()
    private let bottonLine = UIView()

    init() {
        super.init(frame: .zero)
        configure()
        setConstraints()
    }

    private func configure() {
        backgroundColor = .systemGray3
        titleLabel.text = "Settings"
        titleLabel.textAlignment = .center
        titleLabel.font = .openSans(ofSize: 24, style: .bold)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        addSubviews(closeButton, titleLabel, doneButton, bottonLine)

        closeButton.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(40)
            make.leading.bottom.equalToSuperview().inset(15)
        }

        doneButton.snp.makeConstraints { make in
            make.width.height.equalTo(closeButton)
            make.trailing.bottom.equalToSuperview().inset(15)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(doneButton)
            make.leading.equalTo(closeButton.snp.trailing)
            make.trailing.equalTo(doneButton.snp.leading)
            make.bottom.equalToSuperview().inset(15)
        }

        bottonLine.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
