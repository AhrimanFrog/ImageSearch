import UIKit
import SnapKit

class ISDropDownSearchField: UIView {
    let inputField = ISSearchField()
    let currentTypeButton = UIButton()
    private let separationLine = UIView()

    init() {
        super.init(frame: .zero)
        configure()
        setConstraints()
        setColor()
        registerForTraitChanges([UITraitActiveAppearance.self], action: #selector(setColor))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(from type: Preferences.ImageType) {
        currentTypeButton.setTitle(type.description, for: .normal)
    }

    private func configure() {
        separationLine.backgroundColor = .systemGray3
        layer.cornerRadius = 8

        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.image = .init(sfImage: .down)
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 6
        buttonConfig.baseForegroundColor = .label
        buttonConfig.baseBackgroundColor = .systemGray6
        buttonConfig.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .openSans(ofSize: 14, style: .light)
            return outgoing
        }
        currentTypeButton.configuration = buttonConfig
        currentTypeButton.layer.cornerRadius = 8
        setText(from: .all)
    }

    @objc func setColor() {
        layer.backgroundColor = UIColor.systemGray6.cgColor
    }

    private func setConstraints() {
        addSubviews(inputField, currentTypeButton, separationLine)

        inputField.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(100)
        }

        currentTypeButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(inputField.snp.trailing)
        }

        separationLine.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(currentTypeButton.snp.leading)
            make.width.equalTo(2)
        }
    }
}
