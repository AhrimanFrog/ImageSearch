import UIKit
import SnapKit

class AccessDeniedView: UIView {
    private let image = UIImageView(image: UIImage(sfImage: .photoAccessDenied))
    private let message = ISSettingLabel()
    private let toSettingsButton = ISButton(
        title: String(localized: "to_settings"),
        image: UIImage(sfImage: .settings)
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
        toSettingsButton.addAction(UIAction { [weak self] _ in self?.toSettings() }, for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func toSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }

    private func configure() {
        message.text = String(localized: "grant_access")
        message.numberOfLines = 0
        message.textAlignment = .center
        image.tintColor = .customPurple
    }

    private func setConstraints() {
        addSubviews(image, message, toSettingsButton)

        message.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }

        image.snp.makeConstraints { make in
            make.centerX.equalTo(message)
            make.bottom.equalTo(message.snp.top).inset(-6)
            make.height.width.equalTo(80)
        }

        toSettingsButton.snp.makeConstraints { make in
            make.top.equalTo(message.snp.bottom).inset(-6)
            make.horizontalEdges.equalTo(message).inset(30)
            make.height.lessThanOrEqualTo(42)
        }
    }
}
