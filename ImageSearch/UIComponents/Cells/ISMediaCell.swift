import UIKit
import SnapKit
import Combine

class ISMediaCell: UICollectionViewCell, ReuseIdentifiable {
    let imageView = UIImageView()

    private var imageSubscription: AnyCancellable?

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
    }

    func subscribe(to publisher: AnyPublisher<UIImage, Never>?) {
        imageSubscription = publisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.imageView.image = $0 }
    }

    func configure() {
        addSubview(imageView)
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
