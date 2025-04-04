import CropViewController
import UIKit
import Photos
import SnapKit

class ImageCropScreen: UIViewController {
    private let topBanner = UIView()
    private let header = ISHeaderBlock()
    private let cropController: CropViewController

    init(image: UIImage, library: PHPhotoLibrary, errorHandler: @escaping (String) -> Void) {
        self.cropController = .init(image: image)
        super.init(nibName: nil, bundle: nil)
        configure(library: library, errorHandler: errorHandler)
        setConstraints()
    }

    @MainActor
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(library: PHPhotoLibrary, errorHandler: @escaping (String) -> Void) {
        topBanner.backgroundColor = .systemBackground
        addChild(cropController)
        cropController.addImageSaver(library: library) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: self?.dismiss(animated: true)
                case .failure(let error): errorHandler(error.localizedDescription)
                }
            }
        }
    }

    private func setConstraints() {
        view.addSubviews(header, topBanner, cropController.view)

        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }

        topBanner.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(header.snp.top)
        }

        cropController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(header.snp.bottom)
        }
    }
}
