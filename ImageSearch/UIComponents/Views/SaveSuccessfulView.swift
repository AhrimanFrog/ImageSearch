import UIKit
import SnapKit

class SaveSuccessfulView: UIView {
    private let checkmarkView = UIImageView(image: .init(sfImage: .checkmark))
    private let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        checkmarkView.tintColor = .systemGray2
        textLabel.text = String(localized: "save_successful")
        textLabel.numberOfLines = 2
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.font = .openSans(ofSize: 18, style: .medium)
        textLabel.textColor = .systemGray2
        textLabel.textAlignment = .center
    }

    private func setConstraints() {
        addSubviews(checkmarkView, textLabel)

        checkmarkView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(52)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(checkmarkView.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
