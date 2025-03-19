import UIKit

class LocalScreenFactory {
    func build() -> UIViewController {
        return HostingController(contentView: LocalPhotosScreen(viewModel: .init()))
    }
}
