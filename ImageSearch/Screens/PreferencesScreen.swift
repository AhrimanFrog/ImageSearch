import UIKit
import SnapKit
import Combine

class PreferencesScreen: UIView, Screen {
    weak var owner: UIViewController?

    private let headerBlock = ISSettingsHeaderBlock()
    private let imageTypePicker = ISPickerLabel(frame: .zero)
    private let orientationPicker = ISPickerLabel(frame: .zero)
    private let minWidthLabel = ISSettingLabel()
    private let minWidthInput = ISTextField(keyboard: .digitsOnly)
    private let minHeightLabel = ISSettingLabel()
    private let minHeightInput = ISTextField(keyboard: .digitsOnly)
    private let safeSerach = UISwitch()
    private let safeSearchLabel = ISSettingLabel()
    private let orderPicker = ISPickerLabel(frame: .zero)

    private let originalPreferences: CurrentValueSubject<Preferences, Never>
    private let draftPreferences: CurrentValueSubject<Preferences, Never>
    private let completion: () -> Void

    private var changesSubscriptions = Set<AnyCancellable>()

    init(preferences: CurrentValueSubject<Preferences, Never>, completion: @escaping () -> Void) {
        originalPreferences = preferences
        draftPreferences = .init(preferences.value)
        self.completion = completion
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func viewDidLoad() {
        configure()
        setConstraints()
        bind()
    }

    private func savePreferences() {
        originalPreferences.send(draftPreferences.value)
        completion()
    }

    private func bind() {
        headerBlock.closeButton.addAction(UIAction { [weak self] _ in self?.completion() }, for: .touchUpInside)
        headerBlock.doneButton.addAction(UIAction { [weak self] _ in self?.savePreferences() }, for: .touchUpInside)
        imageTypePicker.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                spawnTable(
                    forValue: draftPreferences.value.imageType, ofComponent: imageTypePicker
                ) { [draftPreferences] in draftPreferences.value.imageType = $0 }
            },
            for: .touchUpInside
        )
        draftPreferences
            .map(\.imageType)
            .removeDuplicates()
            .sink { [weak self] in self?.imageTypePicker.stateLabel.text = $0.description }
            .store(in: &changesSubscriptions)
        orientationPicker.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                spawnTable(
                    forValue: draftPreferences.value.orientation, ofComponent: orientationPicker
                ) { [draftPreferences] in draftPreferences.value.orientation = $0 }
            },
            for: .touchUpInside
        )
        draftPreferences
            .map(\.orientation)
            .removeDuplicates()
            .sink { [weak self] in self?.orientationPicker.stateLabel.text = $0.description }
            .store(in: &changesSubscriptions)
        orderPicker.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                spawnTable(
                    forValue: draftPreferences.value.order, ofComponent: orderPicker
                ) { [draftPreferences] in draftPreferences.value.order = $0 }
            },
            for: .touchUpInside
        )
        draftPreferences
            .map(\.order)
            .removeDuplicates()
            .sink { [weak self] in self?.orderPicker.stateLabel.text = $0.description }
            .store(in: &changesSubscriptions)
        safeSerach.publisher(for: \.isOn)
            .sink { [weak self] in self?.draftPreferences.value.safeSerach = $0 }
            .store(in: &changesSubscriptions)
        minWidthInput.publisher(for: \.text)
            .map { Int($0 ?? "0") ?? 0 }
            .sink { [weak self] in self?.draftPreferences.value.minWidth = $0 }
            .store(in: &changesSubscriptions)
        minHeightInput.publisher(for: \.text)
            .map { Int($0 ?? "0") ?? 0 }
            .sink { [weak self] in self?.draftPreferences.value.minHeight = $0 }
            .store(in: &changesSubscriptions)
        Publishers.CombineLatest(draftPreferences, originalPreferences)
            .map { $0 != $1 }
            .assign(to: \.isEnabled, on: headerBlock.doneButton)
            .store(in: &changesSubscriptions)
    }

    private func configure() {
        backgroundColor = .systemBackground
        imageTypePicker.label.text = String(localized: "image_type")
        orientationPicker.label.text = String(localized: "orientation")
        minWidthInput.text = String(originalPreferences.value.minWidth)
        minHeightInput.text = String(originalPreferences.value.minHeight)
        safeSerach.isOn = originalPreferences.value.safeSerach
        orderPicker.label.text = String(localized: "order")
        safeSerach.onTintColor = .customPurple
        minWidthLabel.text = String(localized: "minimal_width")
        minHeightLabel.text = String(localized: "minimal_height")
        safeSearchLabel.text = String(localized: "safe_search")
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
