import UIKit
import SnapKit

class PreferencesScreen: UIView, Screen {
    private let headerBlock = ISSettingsHeaderBlock()
    private let imageTypePicker = ISPickerLabel(frame: .zero)
    private let orientationPicker = ISPickerLabel(frame: .zero)
    private let minWidthLabel = ISSettingLabel()
    private let minWidthInput = ISTextField()
    private let minHeightLabel = ISSettingLabel()
    private let minHeightInput = ISTextField()
    private let safeSerach = UISwitch()
    private let safeSearchLabel = ISSettingLabel()
    private let orderPicker = ISPickerLabel(frame: .zero)

    func viewDidLoad() {
        configure()
        setConstraints()
    }

    private func configure() {
        imageTypePicker.text = "Image Type"
        orientationPicker.text = "Orientation"
        minWidthInput.placeholder = "0"
        minHeightInput.placeholder = "0"
        orderPicker.text = "Order"
        safeSerach.onTintColor = .customPurple
        minWidthLabel.text = "Minimal Width"
        minHeightLabel.text = "Minimal Height"
        safeSearchLabel.text = "Safe Search"
    }

    private func setConstraints() {
        addSubviews(
            headerBlock,
            imageTypePicker,
            orientationPicker,
            minWidthLabel,
            minWidthInput,
            minHeightLabel,
            minHeightInput,
            safeSerach,
            orderPicker,
            safeSearchLabel
        )

        headerBlock.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalToSuperview()
            make.height.equalTo(110)
        }
        imageTypePicker.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(12)
            make.top.equalTo(headerBlock.snp.bottom).inset(-16)
            make.height.equalTo(40)
        }
        orientationPicker.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(imageTypePicker)
            make.top.equalTo(imageTypePicker.snp.bottom).inset(-16)
        }
        minWidthLabel.snp.makeConstraints { make in
            make.leading.height.equalTo(imageTypePicker)
            make.top.equalTo(orientationPicker.snp.bottom).inset(-16)
        }
        minWidthInput.snp.makeConstraints { make in
            make.trailing.height.equalTo(imageTypePicker)
            make.width.equalTo(40)
            make.top.equalTo(orientationPicker.snp.bottom).inset(-16)
        }
        minHeightLabel.snp.makeConstraints { make in
            make.leading.height.equalTo(imageTypePicker)
            make.top.equalTo(minWidthInput.snp.bottom).inset(-16)
        }
        minHeightInput.snp.makeConstraints { make in
            make.trailing.height.leading.equalTo(minWidthInput)
            make.top.equalTo(minWidthInput.snp.bottom).inset(-16)
        }
        orderPicker.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(imageTypePicker)
            make.top.equalTo(minHeightInput.snp.bottom).inset(-16)
        }
        safeSerach.snp.makeConstraints { make in
            make.top.equalTo(orderPicker.snp.bottom).inset(-16)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(12)
        }
        safeSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(safeSerach)
            make.height.leading.equalTo(minHeightLabel)
        }
    }
}

#Preview {
    HostingController(contentView: PreferencesScreen())
}
