import UIKit
import SnapKit

class ISSharedCell: ISMediaCell {
    private let shareButton = ISGreyButton(image: .share)

    var image: UIImage { imageView.image ?? .notFound }

    override func configure() {
        super.configure()
        addSubview(shareButton)
        shareButton.addAction(
            UIAction { [weak self] _ in
                guard let self, let source = imageSource?.largeImageURL else { return }
                touchHandler?(.share(image, source))
            },
            for: .touchUpInside
        )
        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.trailing.top.equalToSuperview().inset(20)
        }
    }
}
