import UIKit

class LocalSearchCoordinator: Coordinator {
    enum Destination {
        case localPhotos, transformation
    }

    let navigationController = UINavigationController()

    init() {
        navigationController.tabBarItem = .init(
            title: String(localized: "change"),
            image: .init(sfImage: .change),
            tag: 1
        )
    }

    func start() {
    }

    func navigate(to: Destination) { // swiftlint:disable:this identifier_name
    }

    func handleError(with text: String) {
        print(text)
    }
}
