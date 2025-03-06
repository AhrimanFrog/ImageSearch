import UIKit

class ISTextField: UITextField {
    enum KyeboardType {
        case digitsOnly, all
    }

    init(keyboard: KyeboardType = .all) {
        super.init(frame: .zero)
        addDoneButton()
        setColor()
        delegate = self
        layer.cornerRadius = 8
        registerForTraitChanges([UITraitActiveAppearance.self], action: #selector(setColor))
        keyboardType = keyboard == .digitsOnly ? .numberPad : .default
    }

    var input: String { text ?? "" }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func setColor() {
        layer.backgroundColor = UIColor.systemGray6.cgColor
    }

    private func addDoneButton() {
        let doneButton = UIBarButtonItem(
            systemItem: .done, primaryAction: UIAction { [weak self] _ in self?.resignFirstResponder() }
        )
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 50))
        toolbar.items = [doneButton]
        inputAccessoryView = toolbar
    }
}

extension ISTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
