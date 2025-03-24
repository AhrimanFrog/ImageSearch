import UIKit

protocol Coordinator {
    var mainController: UIViewController { get }
    func start()
    func handleError(with: String)
}

extension Coordinator {
    func handleError(with text: String) {
        let alert = UIAlertController(title: "Oops!", message: text, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        mainController.present(alert, animated: true)
    }
}
