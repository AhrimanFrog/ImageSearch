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
        label.font = .openSans(ofSize: 14, style: .light)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
