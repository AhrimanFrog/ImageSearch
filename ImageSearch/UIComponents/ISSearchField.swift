import UIKit

class ISSearchField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    init() {
        super.init(frame: .zero)
        configure()
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        placeholder = "Search images, vectors and more"
        layer.backgroundColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1).cgColor
        layer.cornerRadius = 8
    }
}
