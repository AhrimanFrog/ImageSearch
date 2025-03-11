import UIKit
import SnapKit

class ISPhotoInfoBlock: UIView {
    let shareButton = ISButton(title: String(localized: "share"), image: .share, style: .plain)
    private let licenceTitleLabel = UILabel()
    private let license = ISCommentLabel()
    let downloadButton = ISButton(title: String(localized: "download"), image: .download)
    private let photoFormatLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImageFormat(toFormatOf image: ISImage) {
        let format = image.largeImageURL.split(separator: ".").last
        photoFormatLabel.text = String(localized: "photo_format_\(format?.uppercased() ?? "unknown")")
    }

    private func configure() {
        backgroundColor = .systemBackground
        licenceTitleLabel.text = String(localized: "app_license")
        licenceTitleLabel.textColor = .customPurple
        licenceTitleLabel.font = .openSans(ofSize: 14, style: .light)
        license.text = String(localized: "license")
        license.numberOfLines = 2
        photoFormatLabel.font = .openSans(ofSize: 14, style: .light)
    }

    private func setConstraints() {
        addSubviews(shareButton, licenceTitleLabel, license, downloadButton, photoFormatLabel)

        licenceTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(90)
            make.height.lessThanOrEqualTo(22)
        }

        photoFormatLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
            make.height.equalTo(licenceTitleLabel)
            make.width.lessThanOrEqualTo(134)
        }

        shareButton.snp.makeConstraints { make in
            make.trailing.width.equalTo(photoFormatLabel)
            make.height.lessThanOrEqualTo(32)
            make.top.equalTo(photoFormatLabel.snp.bottom).inset(-16)
        }

        downloadButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(26)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(shareButton.snp.bottom).inset(-26)
        }
    
        license.snp.makeConstraints { make in
            make.leading.equalTo(licenceTitleLabel)
            make.bottom.equalTo(downloadButton.snp.top).inset(-12)
            make.top.equalTo(licenceTitleLabel.snp.bottom).inset(-5)
            make.trailing.equalTo(shareButton.snp.leading).inset(-22)
        }
    }
}
