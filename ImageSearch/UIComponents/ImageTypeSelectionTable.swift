import UIKit

class ImageTypeSelectionTable: UITableViewController {
    private let allowedChoises: [Preferences.ImageType]

    init(activeType: Preferences.ImageType) {
        allowedChoises = Preferences.ImageType.allCases.filter { $0 != activeType }
        super.init(style: .plain)
        modalPresentationStyle = .popover
        tableView.register(ISTypeCell.self, forCellReuseIdentifier: ISTypeCell.reuseID)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        return allowedChoises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ISTypeCell.reuseID, for: indexPath
        ) as! ISTypeCell // swiftlint:disable:this force_cast
        cell.label.text = allowedChoises[indexPath.row].rawValue
        return cell
    }
}
