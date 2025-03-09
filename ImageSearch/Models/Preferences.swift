import Combine
import Foundation

struct Preferences: Equatable {
    static func == (lhs: Preferences, rhs: Preferences) -> Bool {
        return lhs.asDict == rhs.asDict
    }

    enum ImageType: String, CaseIterable, CustomStringConvertible {
        case all, photo, illustration, vector

        var description: String { self.rawValue } // temporary; will be changed after localization is implemented
    }

    enum Orientation: String, CaseIterable, CustomStringConvertible {
        case all, horizontal, vertical

        var description: String { self.rawValue } // temporary; will be changed after localization is implemented
    }

    enum Order: String, CaseIterable, CustomStringConvertible {
        case popular, latest

        var description: String { self.rawValue } // temporary; will be changed after localization is implemented
    }

    let imageType = CurrentValueSubject<ImageType, Never>(.all)
    var orientation = CurrentValueSubject<Orientation, Never>(.all)
    var minWidth: Int = 0
    var minHeight: Int = 0
    var safeSerach: Bool = false
    var order = CurrentValueSubject<Order, Never>(.popular)

    var asDict: [String: String] {
        return [
            "image_type": imageType.value.rawValue,
            "orientation": orientation.value.rawValue,
            "min_width": String(minWidth),
            "min_height": String(minHeight),
            "order": order.value.rawValue,
            "safesearch": String(safeSerach)
        ]
    }
}
