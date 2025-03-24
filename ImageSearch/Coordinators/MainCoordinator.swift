import UIKit

class MainCoordinator: Coordinator {
    var children: [Coordinator] = []

    var mainController: UIViewController { tabBarController }

    private let window: UIWindow
    private let tabBarController: UITabBarController

    init(window: UIWindow) {
        self.window = window
        tabBarController = .init()
        tabBarController.tabBar.tintColor = .customPurple
        tabBarController.tabBar.backgroundColor = .systemBackground
        window.rootViewController = tabBarController
    }

    func start() {
        let networkCoordinator = NetworkSearchCoordinator()
        let localCoordinator = LocalSearchCoordinator()
        networkCoordinator.start()
        localCoordinator.start()
        children = [networkCoordinator, localCoordinator]
        tabBarController.setViewControllers(
            [networkCoordinator.mainController, localCoordinator.mainController],
            animated: true
        )
        window.makeKeyAndVisible()
    }
}
