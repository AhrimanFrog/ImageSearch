import UIKit

final class PopoverPresentationDelegate: NSObject, UIPopoverPresentationControllerDelegate {
    static let shared = PopoverPresentationDelegate()

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
