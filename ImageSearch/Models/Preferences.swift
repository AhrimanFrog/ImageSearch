import Combine
import Foundation

struct Preferences: Equatable {
    enum ImageType: String, CaseIterable, CustomStringConvertible {
        case all, photo, illustration, vector

        var description: String { String(localized: String.LocalizationValue(stringLiteral: rawValue)) }
    }

    enum Orientation: String, CaseIterable, CustomStringConvertible {
        case all, horizontal, vertical

        var description: String { String(localized: String.LocalizationValue(stringLiteral: rawValue)) }
    }

    enum Order: String, CaseIterable, CustomStringConvertible {
        case popular, latest

        var description: String { String(localized: String.LocalizationValue(stringLiteral: rawValue)) }
    }

    var imageType: ImageType = .all
    var orientation: Orientation = .all
    var minWidth: Int = 0
    var minHeight: Int = 0
    var safeSerach: Bool = false
    var order: Order = .popular

    var asDict: [String: String] {
        return [
            "image_type": imageType.rawValue,
            "orientation": orientation.rawValue,
            "min_width": String(minWidth),
            "min_height": String(minHeight),
            "order": order.rawValue,
            "safesearch": String(safeSerach)
        ]
    }
}
