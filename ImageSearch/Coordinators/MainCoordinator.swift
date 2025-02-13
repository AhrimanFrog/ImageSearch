import UIKit

class MainCoordinator: Coordinator {
    enum Destination {
        case start
        case results(APIImagesResponse, String)
        case photo(ISImage, APIImagesResponse)
    }

    private let window: UIWindow
    private let navigationController: UINavigationController
    private let screenFactory: ScreenFactory

    init(window: UIWindow) {
        screenFactory = ScreenFactory()
        navigationController = .init(rootViewController: screenFactory.build(screen: .start))
        self.window = window
        self.window.rootViewController = navigationController
        screenFactory.navigationHandler = self
    }

    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        window.makeKeyAndVisible()
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .start:
            navigationController.popToRootViewController(animated: true)
        case let .results(response, request):
            navigationController.pushViewController(
                screenFactory.build(screen: .results(response, request)), animated: true
            )
        default:
            fatalError("Not implemented")
        }
    }

    func handleError(with text: String) {
        let alert = UIAlertController(title: "Oops!", message: text, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}
