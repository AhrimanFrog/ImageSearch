import CropViewController
import UIKit
import Photos
import SnapKit
import Combine

class ImageCropScreen: UIViewController {
    struct CropControllerDependencies {
        let image: UIImage
        let library: PHPhotoLibrary
        let errorHandler: (String) -> Void
    }

    private let topBanner = UIView()
    private let header = ISHeaderBlock()
    private let cropController: CropViewController
    private let viewModel: ImageCropViewModel

    init(dependencies: CropControllerDependencies, viewModel: ImageCropViewModel) {
        self.cropController = .init(image: dependencies.image)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure(library: dependencies.library, errorHandler: dependencies.errorHandler)
        setConstraints()
    }

    @MainActor
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(library: PHPhotoLibrary, errorHandler: @escaping (String) -> Void) {
        topBanner.backgroundColor = .systemBackground
        header.delegate = viewModel
        addChild(cropController)
        cropController.addImageSaver(library: library) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: self?.navigationController?.popViewController(animated: true)
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

class ImageCropViewModel: ViewModel, HeaderViewDelegate {
    struct Dependencies {
        let networkManager: NetworkManager
        let preferences: Preferences
        let navigationHandler: NavigationHandler
    }

    private let dependencies: Dependencies
    private var requestSubscription: AnyCancellable?

    var navigationHandler: NavigationHandler { dependencies.navigationHandler }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func displayResults(of query: String) {
        requestSubscription = dependencies.networkManager
            .getImages(query: query, page: 1, userPreferences: dependencies.preferences)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let respponse): self?.navigationHandler(.success(.results(respponse, query)))
                case .failure(let error): self?.navigationHandler(.failure(error))
                }
            }
    }
}
