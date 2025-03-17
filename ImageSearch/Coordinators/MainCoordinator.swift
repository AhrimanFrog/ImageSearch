import UIKit

class MainCoordinator: Coordinator {
    var children: [Coordinator] = []

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
            [networkCoordinator.navigationController, localCoordinator.navigationController],
            animated: true
        )
        window.makeKeyAndVisible()
    }
}
