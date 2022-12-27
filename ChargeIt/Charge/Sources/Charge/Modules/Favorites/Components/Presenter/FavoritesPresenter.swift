//
//  FavoritesPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// Presenter of the Favorites module.
final class FavoritesPresenter {
    
    // MARK: VIPER
    private let interactor: FavoritesInteractor
    private let router: FavoritesRouter
    weak var view: FavoritesViewProtocol?
    
    // MARK: Private Properties
    private var viewModels: [DetailPointViewModel] = []
    
    // MARK: Initializers
    init(interactor: FavoritesInteractor, router: FavoritesRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: Private Methods
    private func loadFavorites() {
        do {
            let favoritesObj = try interactor.allFavorites()
            var favorites: [DetailPointViewModel] = []
            
            favoritesObj.forEach {
                let viewModel = Converter().makeViewModel(from: $0) { _ in }
                favorites.append(viewModel)
            }
            
            viewModels = favorites
            view?.set(points: favorites)
        } catch {
            view?.showErrorAlert(with: error.localizedDescription)
        }
    }
}

// MARK: - FavoritesPresenterProtocol
extension FavoritesPresenter: FavoritesPresenterProtocol {
    
    func viewDidLoad() {
        loadFavorites()
    }
    
    func viewDidAppear() {
        loadFavorites()
    }
    
    func itemTapped(at index: Int) {
        router.revealDetail(with: viewModels[index])
    }
    
    func requestDeletion(at index: Int) {
        do {
            try interactor.deletePoint(by: viewModels[index].uuid)
            let deleted = viewModels.remove(at: index)
            view?.remove(point: deleted)
        } catch {
            view?.showErrorAlert(with: "Unable to delete the point")
        }
    }
}
