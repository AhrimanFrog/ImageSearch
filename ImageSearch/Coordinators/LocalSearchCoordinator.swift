import UIKit

class LocalSearchCoordinator: Coordinator {
    enum Destination {
        case localPhotos
        case transformation(UIImage)
    }

    var mainController: UIViewController { navigationController }

    private let navigationController: UINavigationController
    private let screenFactory = LocalScreenFactory()

    init() {
        navigationController = .init(rootViewController: screenFactory.build(screen: .localPhotos))
        navigationController.tabBarItem = .init(
            title: String(localized: "change"),
            image: .init(sfImage: .change),
            tag: 1
        )
        navigationController.isNavigationBarHidden = true
    }

    func start() {
        screenFactory.navigationHandler = self
    }

    func navigate(to screen: Destination) {
        switch screen {
        case .localPhotos: navigationController.dismiss(animated: true)
        case .transformation: navigationController.present(screenFactory.build(screen: screen), animated: true)
        }
    }
}
