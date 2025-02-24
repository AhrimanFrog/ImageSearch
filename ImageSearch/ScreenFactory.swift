import UIKit

class ScreenFactory {
    weak var navigationHandler: MainCoordinator?

    enum Destination {
        case start, results, photo
    }

    private let networkManager = NetworkManager()

    func build(screen: MainCoordinator.Destination) -> UIViewController {
        switch screen {
        case .start: return HostingController(contentView: titleScreen())
        case let .results(response, request): return HostingController(contentView: resultsScreen(response, request))
        case let .photo(mainImage, related): return HostingController(contentView: photoScreen(mainImage, related))
        }
    }

    private func titleScreen() -> TitleSearchScreen {
        let titleViewModel = TitleSearchViewModel(networkManager: networkManager) { [weak self] result in
            switch result {
            case let .success((response, request)): self?.navigationHandler?.navigate(to: .results(response, request))
            case .failure(let error): self?.navigationHandler?.handleError(with: error.errorDescription)
            }
        }
        return TitleSearchScreen(viewModel: titleViewModel)
    }

    private func resultsScreen(_ response: APIImagesResponse, _ request: String) -> SearchResultsScreen {
        let dependencies = SearchResultsViewModel.Dependencies(
            networkManager: networkManager,
            initialResults: response,
            query: request
        ) { [weak self] in self?.navigationHandler?.recieveStateChange($0) }
        return SearchResultsScreen(viewModel: SearchResultsViewModel(dependencies: dependencies))
    }

    private func photoScreen(_ mainImage: ISImage, _ related: [ISImage]) -> PhotoScreen {
        let dependencies = PhotoScreenViewModel.Dependencies(
            networkManager: networkManager,
            topImage: mainImage,
            related: related
        ) { [weak self] in self?.navigationHandler?.recieveStateChange($0) }
        return PhotoScreen(viewModel: .init(dependencies: dependencies))
    }
}
