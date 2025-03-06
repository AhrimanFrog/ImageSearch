import UIKit
import Combine

typealias Enumerable = CaseIterable & Equatable & CustomStringConvertible

class PopoverSelectionTable<Value: Enumerable>: UITableViewController {
    private let publisher: CurrentValueSubject<Value, Never>
    private let allowedChoises: [Value]

    init(publisher: CurrentValueSubject<Value, Never>) {
        self.publisher = publisher
        allowedChoises = Value.allCases.filter { $0 != publisher.value }
        super.init(style: .plain)
        tableView.register(ISTypeCell.self, forCellReuseIdentifier: ISTypeCell.reuseID)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = tableView.contentSize
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
        cell.label.text = allowedChoises[indexPath.row].description
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        publisher.send(allowedChoises[indexPath.row])
    }
}
