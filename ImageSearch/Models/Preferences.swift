import Combine
import Foundation

struct Preferences: Equatable {
    static func == (lhs: Preferences, rhs: Preferences) -> Bool {
        return lhs.asDict == rhs.asDict
    }

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

    let imageType = CurrentValueSubject<ImageType, Never>(.all)
    let orientation = CurrentValueSubject<Orientation, Never>(.all)
    var minWidth: CurrentValueSubject<Int, Never> = .init(0)
    var minHeight: CurrentValueSubject<Int, Never> = .init(0)
    var safeSerach: CurrentValueSubject<Bool, Never> = .init(false)
    let order = CurrentValueSubject<Order, Never>(.popular)

    var asDict: [String: String] {
        return [
            "image_type": imageType.value.rawValue,
            "orientation": orientation.value.rawValue,
            "min_width": String(minWidth.value),
            "min_height": String(minHeight.value),
            "order": order.value.rawValue,
            "safesearch": String(safeSerach.value)
        ]
    }

    var changed: AnyPublisher<Void, Never> {
        return imageType
            .void()
            .merge(with: orientation.void(), minWidth.void(), minHeight.void(), safeSerach.void(), order.void())
            .eraseToAnyPublisher()
    }
}
