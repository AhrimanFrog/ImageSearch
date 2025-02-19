import UIKit
import SnapKit
import Combine

class PhotoScreen: ISScreen<PhotoScreenViewModel> {
    private let header = ISHeader()
    private let photoImage = UIImageView()
    private let zoomButton = UIButton()
    private let shareButton = ISButton(title: "Share", image: .search)
    private let licenceTitleLabel = UILabel()
    private let licence = ISCommentLabel()
    private let downloadButton = ISButton(title: "Download", image: .download)
    private let releatedLabel = ISInfoLabel()
    private let reletadCollection = UICollectionView()
}


class PhotoScreenViewModel: ViewModel {
    
}
