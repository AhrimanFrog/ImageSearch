import UIKit
import SnapKit

final class TitleSearchScreen: ISScreen<TitleSearchViewModel> {
    private let title = ISTitleLabel()
    private let searchField = ISSearchField()
    private let searchButton = ISButton(title: "Search", image: .search)
    private let backgroundImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configure()
        setConstraints()
    }

    private func bind() {
    }

    private func configure() {
        backgroundImage.image = .init(resource: .titleBackground)
        backgroundImage.alpha = 0.5
    }

    private func setConstraints() {
        addSubviews(backgroundImage, title, searchField, searchButton)
        backgroundImage.snp.makeConstraints { $0.edges.equalToSuperview() }

        title.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(240)
            make.height.lessThanOrEqualTo(200)
        }

        searchField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(title.snp.bottom).inset(-50)
            make.height.equalTo(52)
        }

        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(searchField)
            make.top.equalTo(searchField.snp.bottom).inset(-20)
        }
    }
}

final class TitleSearchViewModel: ViewModel {
    private let networkManager: NetworkManager

    @Published var images: [ISImage] = []

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}
