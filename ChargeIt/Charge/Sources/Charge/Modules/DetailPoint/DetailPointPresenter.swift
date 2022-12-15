//
//  DetailPointPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// Presenter of the Detail Point module.
final class DetailPointPresenter {
    
    // MARK: Public Properties
    weak var view: DetailPointViewProtocol?
    
    // MARK: Private Properties
    private let router: DetailPointRouterProtocol
    private let interactor: DetailPointInteractorProtocol
    private var viewModel: DetailPointViewModel
    
    // MARK: Initializers
    init(router: DetailPointRouterProtocol, interactor: DetailPointInteractorProtocol, viewModel: DetailPointViewModel) {
        self.router = router
        self.interactor = interactor
        self.viewModel = viewModel
    }
    
}

// MARK: - DetailPointPresenterProtocol
extension DetailPointPresenter: DetailPointPresenterProtocol {
    
    var numberOfConnections: Int {
        viewModel.connections.count
    }
    
    func viewDidLoad() {
        view?.updateUI(with: viewModel)
        view?.setFavorite(state: viewModel.isFavorite)
    }
    
    func connection(at index: Int) -> DetailPointViewModel.ConnectionViewModel {
        viewModel.connections[index]
    }
    
    func favoriteButtonTapped() {
        do {
            try viewModel.didTapFavoriteButton(viewModel.isFavorite)
            viewModel.isFavorite.toggle()
            view?.setFavorite(state: viewModel.isFavorite)
        } catch {
            view?.showAlert(with: "Storage operation failed")
        }
    }
    
    func openMapsButtonTapped() {
        router.openInMaps(latitude: viewModel.latitude, longitude: viewModel.longitude)
    }
    
    func dismiss() {
        router.dismiss()
    }
}
