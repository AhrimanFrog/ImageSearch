import UIKit

final class TitleSearchScreen: ISScreen<TitleSearchViewModel> {
    private let title = UILabel()
    private let searchField = UITextField()
    private let searchButton = UIButton()
    private let backgroundImage = UIImageView()

    override func viewDidLoad() {
    }
}

final class TitleSearchViewModel: ViewModel {
}
