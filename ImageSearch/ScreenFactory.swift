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
        case .results(let response): return HostingController(contentView: resultsScreen(response))
        default: fatalError("Not implemented")
        }
    }

    private func titleScreen() -> TitleSearchScreen {
        let titleViewModel = TitleSearchViewModel(networkManager: networkManager) { [weak self] result in
            switch result {
            case .success(let response): self?.navigationHandler?.navigate(to: .results(response))
            case .failure(let error): self?.navigationHandler?.handleError(with: error.errorDescription)
            }
        }
        return TitleSearchScreen(viewModel: titleViewModel)
    }

    private func resultsScreen(_ response: APIImagesResponse) -> SearchResultsScreen {
        let dependencies = SearchResultsViewModel.Dependencies(
            networkManager: networkManager,
            initialResults: response,
            query: "",
            navigationHandler: {}
        )
        return SearchResultsScreen(viewModel: SearchResultsViewModel(dependencies: dependencies))
    }
}
