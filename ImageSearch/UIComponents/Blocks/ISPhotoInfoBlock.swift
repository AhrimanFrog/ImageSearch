import UIKit
import SnapKit

class ISPhotoInfoBlock: UIView {
    private let shareButton = ISButton(title: "Share", image: .share, style: .plain)
    private let licenceTitleLabel = UILabel()
    private let licence = ISCommentLabel()
    private let downloadButton = ISButton(title: "Download", image: .download)
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
        photoFormatLabel.text = "Photo in .\(format?.uppercased() ?? "unknown") format"
    }

    private func configure() {
        backgroundColor = .systemBackground
        licenceTitleLabel.text = "APP License"
        licenceTitleLabel.textColor = .customPurple
        licenceTitleLabel.font = .openSans(ofSize: 14, style: .light)
        licence.text = "Free for commercial use\nNo attribution required"
        licence.numberOfLines = 2
        photoFormatLabel.font = .openSans(ofSize: 14, style: .light)
    }

    private func setConstraints() {
        addSubviews(shareButton, licenceTitleLabel, licence, downloadButton, photoFormatLabel)

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

        licence.snp.makeConstraints { make in
            make.leading.equalTo(licenceTitleLabel)
            make.bottom.equalTo(shareButton)
            make.top.equalTo(licenceTitleLabel.snp.bottom).inset(-5)
            make.width.lessThanOrEqualTo(166)
        }

        downloadButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(26)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(licence.snp.bottom).inset(-26)
        }
    }
}
