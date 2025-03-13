import UIKit

class LocalSearchCoordinator: Coordinator {
    enum Destination {
        case localPhotos, transformation
    }

    func start() {
    }
    
    func navigate(to: Destination) { // swiftlint:disable:this identifier_name
        
    }

    func handleError(with text: String) {
        print(text)
    }
}
