import UIKit

class ScreenFactory {
    weak var navigationHandler: MainCoordinator?

    private let networkManager = NetworkManager()
    private let preferences = Preferences()

    func build(screen: MainCoordinator.Destination) -> UIViewController {
        let controller = switch screen {
        case .start: HostingController(contentView: titleScreen())
        case let .results(response, request): HostingController(contentView: resultsScreen(response, request))
        case let .photo(mainImage, related): HostingController(contentView: photoScreen(mainImage, related))
        case let .zoom(image): HostingController(contentView: zoomScreen(image: image))
        case .preferences: HostingController(contentView: preferencesScreen())
        }
        controller.isHeroEnabled = true
        return controller
    }

    private func titleScreen() -> TitleSearchScreen {
        let titleViewModel = TitleSearchViewModel(
            networkManager: networkManager,
            preferences: preferences,
            manageChoiceTable: { [weak self] newState in self?.navigationHandler?.modalController(toState: newState) },
            coordinatorNotifier: { [weak self] result in
                switch result {
                case let .success((response, request)):
                    self?.navigationHandler?.navigate(to: .results(response, request))
                case .failure(let error):
                    self?.navigationHandler?.handleError(with: error.errorDescription)
                }
            }
        )
        return TitleSearchScreen(viewModel: titleViewModel)
    }

    private func resultsScreen(_ response: APIImagesResponse, _ request: String) -> SearchResultsScreen {
        let dependencies = SearchResultsViewModel.Dependencies(
            networkManager: networkManager,
            preferences: preferences,
            initialResults: response,
            query: request,
            navigationHandler: { [weak self] in self?.navigationHandler?.recieveStateChange($0) },
            share: { [weak self] image, link in self?.navigationHandler?.share(image: image, link: link) }
        )
        return SearchResultsScreen(viewModel: SearchResultsViewModel(dependencies: dependencies))
    }

    private func photoScreen(_ mainImage: ISImage, _ related: [ISImage]) -> PhotoScreen {
        let dependencies = PhotoScreenViewModel.Dependencies(
            networkManager: networkManager,
            preferences: preferences,
            topImage: mainImage,
            related: related,
            navigationHandler: { [weak self] in self?.navigationHandler?.recieveStateChange($0) },
            share: { [weak self] image, link in self?.navigationHandler?.share(image: image, link: link) }
        )
        return PhotoScreen(viewModel: .init(dependencies: dependencies))
    }

    private func zoomScreen(image: UIImage?) -> ZoomScreen {
        return ZoomScreen(image: image) { [weak self] in self?.navigationHandler?.modalController(toState: .dismiss) }
    }

    private func preferencesScreen() -> PreferencesScreen {
        return PreferencesScreen(preferences: preferences) { [weak self] in
            self?.navigationHandler?.modalController(toState: .dismiss)
        }
    }
}
