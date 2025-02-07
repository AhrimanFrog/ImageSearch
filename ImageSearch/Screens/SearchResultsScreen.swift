import UIKit
import SnapKit
import Combine

final class SearchResultsScreen: ISScreen<SearchResultsViewModel> {
    private let homeButton = UIButton()
    private let searchField = ISSearchField()
    private let preferencesButton = UIButton()
    private let totalResultsLabel = UILabel()
    private let relatedLabel = UILabel()
    private let relatedCollection = UICollectionView()
    private let resultsCollection = UICollectionView()
}

final class SearchResultsViewModel: ViewModel {
}
