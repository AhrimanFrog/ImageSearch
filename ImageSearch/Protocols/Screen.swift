import UIKit

protocol Screen: UIView {
    func viewDidLoad()
    var owner: UIViewController? { get set }
}

class ISScreen<VM: ViewModel>: UIView, Screen {
    private(set) var viewModel: VM
    weak var owner: UIViewController?

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    func viewDidLoad() {}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
