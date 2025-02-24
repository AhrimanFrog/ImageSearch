import UIKit

class MainCoordinator: Coordinator {
    enum Destination {
        case start
        case results(APIImagesResponse, String)
        case photo(ISImage, [ISImage])
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

    func recieveStateChange<ERROR: LocalizedError>(_ change: Result<Destination, ERROR>) {
        switch change {
        case .success(let destination): navigate(to: destination)
        case .failure(let error): handleError(with: error.errorDescription ?? "Unknown error")
        }
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .start:
            navigationController.popToRootViewController(animated: true)
        default:
            navigationController.pushViewController(screenFactory.build(screen: destination), animated: true)
        }
    }

    func handleError(with text: String) {
        let alert = UIAlertController(title: "Oops!", message: text, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }

    func share(image: UIImage, link: String) {
        let activityController = UIActivityViewController(
            activityItems: [image, link],
            applicationActivities: nil
        )
        navigationController.present(activityController, animated: true)
    }
}
