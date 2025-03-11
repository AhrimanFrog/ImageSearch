import UIKit

protocol Screen: UIView {
    func viewDidLoad()
    var owner: UIViewController? { get set }
}

extension Screen {
    func spawnTable<Val: Enumerable>(
        forValue value: Val,
        ofComponent component: UIView?,
        onSelect: @escaping (Val) -> Void
    ) {
        let tableController = PopoverSelectionTable(current: value, onSelect: onSelect)
        tableController.modalPresentationStyle = .popover
        if let popoverController = tableController.popoverPresentationController {
            tableController.preferredContentSize = tableController.view.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            )
            popoverController.delegate = PopoverPresentationDelegate.shared
            popoverController.sourceView = component
            popoverController.permittedArrowDirections = [.up, .down]
        }
        owner?.present(tableController, animated: true)
    }
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
