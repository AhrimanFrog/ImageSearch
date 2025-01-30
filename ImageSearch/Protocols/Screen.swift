import UIKit

protocol Screen: UIView {
    associatedtype GenericVM: ViewModel
    var viewModel: GenericVM { get }

    func viewDidLoad()
}

class ISScreen<VM: ViewModel>: UIView, Screen {
    private(set) var viewModel: VM

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    func viewDidLoad() {}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
