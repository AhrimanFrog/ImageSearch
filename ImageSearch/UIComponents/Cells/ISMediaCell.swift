import UIKit
import SnapKit
import Combine

class ISMediaCell: UICollectionViewCell, ReuseIdentifiable {
    enum Touch {
        case photo(ISImage), share(UIImage, String)
    }

    let imageView = UIImageView()

    private var imageSubscription: AnyCancellable?
    private(set) var touchHandler: ((Touch) -> Void)?
    private(set) var imageSource: ISImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageSubscription?.cancel()
        imageView.image = .notFound
        imageSource = nil
    }

    func addSource(_ source: ISImage) {
        imageSource = source
    }

    func subscribe(to publisher: AnyPublisher<UIImage, Never>?) {
        imageSubscription = publisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.imageView.image = $0 }
    }

    func addTouchHandler(_ handler: @escaping (Touch) -> Void) {
        touchHandler = handler
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let source = imageSource else { return }
        touchHandler?(.photo(source))
    }

    func configure() {
        addSubview(imageView)
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
