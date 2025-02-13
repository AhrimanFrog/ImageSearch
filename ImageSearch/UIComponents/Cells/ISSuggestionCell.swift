import UIKit
import SnapKit

class ISSuggestionCell: UICollectionViewCell, ReuseIdentifiable {
    private let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        registerForTraitChanges([UITraitActiveAppearance.self], action: #selector(updateCellColors))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(_ text: String) {
        textLabel.text = text
    }

    @objc private func updateCellColors() {
        layer.backgroundColor = UIColor.systemGray3.cgColor
        layer.borderColor = UIColor.systemGray2.cgColor
    }

    private func configure() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        updateCellColors()

        addSubview(textLabel)
        textLabel.font = .openSans(ofSize: 14, style: .light)
        textLabel.textAlignment = .center

        textLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
