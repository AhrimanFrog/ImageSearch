import UIKit

class NetworkSearchCoordinator: Coordinator {
    enum Destination {
        case start
        case results(APIImagesResponse, String)
        case photo(ISImage, [ISImage])
        case zoom(UIImage?)
        case crop(UIImage)
        case preferences
    }

    enum ModalState {
        case present(UIViewController), dismiss
    }

    var mainController: UIViewController { navigationController }

    private let screenFactory: NetwrokScreenFactory
    private let navigationController: UINavigationController

    init() {
        screenFactory = NetwrokScreenFactory()
        navigationController = .init(rootViewController: screenFactory.build(screen: .start))
        navigationController.tabBarItem = .init(
            title: String(localized: "search"),
            image: .init(sfImage: .search),
            tag: 0
        )
        screenFactory.navigationHandler = self
    }

    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func recieveStateChange(_ change: Result<Destination, any Error>) {
        switch change {
        case .success(let destination): navigate(to: destination)
        case .failure(let error): handleError(with: error.localizedDescription)
        }
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .start:
            navigationController.popToRootViewController(animated: true)
        case .zoom, .preferences:
            let screen = screenFactory.build(screen: destination)
            screen.modalPresentationStyle = .fullScreen
            navigationController.present(screen, animated: true)
        default:
            navigationController.pushViewController(screenFactory.build(screen: destination), animated: true)
        }
    }

    func modalController(toState state: ModalState) {
        switch state {
        case .dismiss: navigationController.dismiss(animated: true)
        case .present(let controller): navigationController.present(controller, animated: true)
        }
    }

    func share(image: UIImage, link: String) {
        let activityController = UIActivityViewController(
            activityItems: [image, link],
            applicationActivities: nil
        )
        navigationController.present(activityController, animated: true)
    }
}
