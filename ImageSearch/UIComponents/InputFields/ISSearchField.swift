import UIKit

class ISSearchField: ISTextField {
    private let padding = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 5)

    init() {
        super.init(keyboard: .all)
        configure()
        registerForTraitChanges([UITraitActiveAppearance.self], action: #selector(setColor))
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

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftViewRect = super.leftViewRect(forBounds: bounds)
        leftViewRect.origin.x += 15
        return leftViewRect
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addInputProcessor(_ processor: @escaping (String) -> Void) {
        addAction(
            UIAction { [weak self] _ in
                guard let text = self?.text, !text.isEmpty else { return }
                processor(text)
            },
            for: .editingDidEnd
        )
    }

    private func configure() {
        placeholder = "Search images, vectors and more"
        layer.cornerRadius = 8
        leftViewMode = .always
        let imageView = UIImageView(image: UIImage(sfImage: .search))
        imageView.tintColor = .systemGray
        leftView = imageView
    }
}
