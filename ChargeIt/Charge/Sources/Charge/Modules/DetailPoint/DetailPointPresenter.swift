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
        interactor.fetchPhotos(with: viewModel.imageURLs)
        viewModel.isFavorite = interactor.isFavorite(by: viewModel.id)
        view?.setFavorite(state: viewModel.isFavorite!)
    }
    
    func connection(at index: Int) -> DetailPointViewModel.ConnectionViewModel {
        viewModel.connections[index]
    }
    
    func imageLoaded(data: Data) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.addImage(with: data)
        }
    }
    
    func imageLoadingFailed(with error: SearchError) { }
    
    func favoriteButtonTapped() {
        guard let isFavorite = viewModel.isFavorite else {
            return
        }
        
        if isFavorite {
            interactor.removeFromFavorites(by: viewModel.id)
            viewModel.isFavorite = false
            view?.setFavorite(state: false)
        } else {
            interactor.addToFavorites(viewModel)
            viewModel.isFavorite = true
            view?.setFavorite(state: true)
        }
    }
}
