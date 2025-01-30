import Foundation

struct Preferences {
    enum ImageType: String {
        case all, photo, illustration, vector
    }

    enum Orientation: String {
        case all, horizontal, vertical
    }

    enum Color: String {
        case grayscale
        case transparent
        case red
        case orange
        case yellow
        case green
        case turquoise
        case blue
        case lilac
        case pink
        case white
        case gray
        case black
        case brown
    }

    enum Order: String {
        case popular, latest
    }
    
    enum Category: String {
        case backgrounds
        case fashion
        case nature
        case science
        case education
        case feelings
        case health
        case people
        case religion
        case places
        case animals
        case industry
        case computer
        case food
        case sports
        case transportation
        case travel
        case buildings
        case business
        case music
    }

    let imageType: ImageType = .all
    let orientation: Orientation = .all
    let category: Category?
    let minWidth: Int = 0
    let minHeight: Int = 0
    let colors: [Color] = []
    let safeSerach: Bool = false
    let order: Order = .popular
    

    var asDict: [String: String] {
        return [
            "image_type": imageType.rawValue,
            "orientation": orientation.rawValue,
            "min_width": String(minWidth),
            "min_height": String(minHeight),
            "order": order.rawValue,
            "safesearch": order.rawValue
        ]
    }
}
