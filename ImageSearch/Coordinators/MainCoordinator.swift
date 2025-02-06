import UIKit

class MainCoordinator: Coordinator {
    enum Destination {
        case start
        case results([ISImage])
        case photo
    }

    private(set) var children: [any Coordinator] = []
    private let window: UIWindow
    private let navigatioinController = UINavigationController()
    private let screenFactory = ScreenFactory()

    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigatioinController
    }

    func start() {
        navigatioinController.setViewControllers([screenFactory.build(screen: .start)], animated: false)
        window.makeKeyAndVisible()
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .start:
            navigatioinController.setViewControllers([screenFactory.build(screen: .start)], animated: true)
        default:
            navigatioinController.pushViewController(screenFactory.build(screen: destination), animated: true)
        }
    }

    func handleError(with text: String) {
        let alert = UIAlertController(title: "Oops!", message: text, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        navigatioinController.present(alert, animated: true)
    }
}
