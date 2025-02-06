import UIKit

class ScreenFactory {
    enum Destination {
        case start, results, photo
    }
    
    private let networkManager = NetworkManager()
    
    func build(screen: MainCoordinator.Destination) -> UIViewController {
        switch screen {
        case .start:
            return HostingController(
                contentView: TitleSearchScreen(viewModel: TitleSearchViewModel(networkManager: networkManager))
            )
        case .results(let photos) :
            return HostingController(
                contentView: TitleSearchScreen(viewModel: TitleSearchViewModel(networkManager: networkManager))
            )
        case .photo:
            return HostingController(
                contentView: TitleSearchScreen(viewModel: TitleSearchViewModel(networkManager: networkManager))
            )
        }
    }
}
