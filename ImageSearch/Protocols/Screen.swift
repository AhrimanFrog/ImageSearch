import UIKit

protocol Screen: UIView {
    associatedtype GenericVM: ViewModel
    var viewModel: GenericVM { get }

    func viewDidLoad() -> Void
}

class ISScreen<VM: ViewModel>: UIView, Screen {
    private(set) var viewModel: VM

    init(viewModel: VM) {
        self.viewModel = viewModel
    }

    func viewDidLoad() {
        preconditionFailure("This method must be overridden")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
