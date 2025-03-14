import UIKit

class MainCoordinator: Coordinator {
    enum Destination {
        case local, global
    }

    private let window: UIWindow
    private let tabBarController: UITabBarController

    init(window: UIWindow) {
        self.window = window
        tabBarController = .init()
        window.rootViewController = tabBarController
    }

    func start() {
        let networkCoordinator = NetworkSearchCoordinator()
        let localCoordinator = LocalSearchCoordinator()
        networkCoordinator.start()
        localCoordinator.start()
        tabBarController.setViewControllers(
            [networkCoordinator.navigationController, localCoordinator.navigationController],
            animated: true
        )
        window.makeKeyAndVisible()
    }

    func navigate(to: Destination) {
    }

    func handleError(with: String) {
    }
}
