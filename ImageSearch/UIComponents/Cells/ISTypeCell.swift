import UIKit
import SnapKit

class ISTypeCell: UITableViewCell, ReuseIdentifiable {
    let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(label)
        label.font = .openSans(ofSize: 18, style: .medium)
        label.textAlignment = .center
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
