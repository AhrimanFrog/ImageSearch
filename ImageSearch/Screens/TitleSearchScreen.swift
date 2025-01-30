import UIKit
import SnapKit

final class TitleSearchScreen: ISScreen<TitleSearchViewModel> {
    private let title = UILabel()
    private let searchField = UITextField()
    private let searchButton = ISButton(title: "Search", image: .search)
    private let backgroundImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configure()
    }

    private func bind() {
        
    }

    private func configure() {
        addSubview(backgroundImage)
        backgroundImage.addSubviews(title, searchField, searchButton)
        backgroundImage.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

final class TitleSearchViewModel: ViewModel {
}
