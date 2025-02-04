import UIKit

class MainCoordinator: Coordinator {
    private(set) var children: [any Coordinator] = []
    private let window: UIWindow
    private let navigatioinController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigatioinController
    }

    func start() {
        let searchController = HostingController(
            contentView: TitleSearchScreen(viewModel: TitleSearchViewModel(networkManager: NetworkManager()))
        )
        navigatioinController.setViewControllers([searchController], animated: false)
        window.makeKeyAndVisible()
    }
}
