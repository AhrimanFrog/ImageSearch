import Combine
import Foundation

class Preferences {
    static let shared = Preferences()

    enum ImageType: String, CaseIterable {
        case all, photo, illustration, vector
    }

    enum Orientation: String {
        case all, horizontal, vertical
    }

    enum Order: String {
        case popular, latest
    }

    let imageType = CurrentValueSubject<ImageType, Never>(.all)
    var orientation: Orientation = .all
    var minWidth: Int = 0
    var minHeight: Int = 0
    var safeSerach: Bool = false
    var order: Order = .popular

    var asDict: [String: String] {
        return [
            "image_type": imageType.value.rawValue,
            "orientation": orientation.rawValue,
            "min_width": String(minWidth),
            "min_height": String(minHeight),
            "order": order.rawValue,
            "safesearch": String(safeSerach)
        ]
    }
}
