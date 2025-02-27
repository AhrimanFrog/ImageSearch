import UIKit
import SnapKit
import Hero

class ZoomScreen: UIView, Screen {
    private let photoView = UIImageView()
    private let scrollView = UIScrollView()
    private let closeButton = ISGreyButton(image: UIImage(sfImage: .close))

    init(image: UIImage?, close: @escaping () -> Void) {
        super.init(frame: .zero)
        photoView.image = image
        closeButton.addAction(UIAction { _ in close() }, for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func viewDidLoad() {
        setConstraints()

        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.bounces = false
        photoView.contentMode = .scaleAspectFit
        photoView.heroID = "photo"
    }

    private func setConstraints() {
        addSubviews(scrollView, closeButton, photoView)

        closeButton.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide)
            make.height.width.equalTo(42)
        }
        scrollView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
        photoView.snp.makeConstraints { $0.edges.equalTo(scrollView) }
    }
}

extension ZoomScreen: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
}
