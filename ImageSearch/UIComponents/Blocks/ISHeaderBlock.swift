import UIKit
import SnapKit

class ISHeaderBlock: UIView {
    let homeButton = UIButton()
    let searchField = ISSearchField()
    let preferencesButton = UIButton()
    private let bottonLine = UIView()

    init() {
        super.init(frame: .zero)
        configure()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = .systemBackground
        bottonLine.backgroundColor = .systemGray2
        homeButton.setBackgroundImage(.logo, for: .normal)
        preferencesButton.setBackgroundImage(.filters, for: .normal)
    }

    private func setConstraints() {
        addSubviews(homeButton, searchField, preferencesButton, bottonLine)

        homeButton.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(52)
            make.leading.bottom.equalToSuperview().inset(6)
        }

        preferencesButton.snp.makeConstraints { make in
            make.width.height.equalTo(homeButton)
            make.trailing.bottom.equalToSuperview().inset(6)
        }

        searchField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(homeButton.snp.trailing).inset(-16)
            make.trailing.equalTo(preferencesButton.snp.leading).inset(-8)
            make.bottom.equalToSuperview().inset(6)
        }

        bottonLine.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
