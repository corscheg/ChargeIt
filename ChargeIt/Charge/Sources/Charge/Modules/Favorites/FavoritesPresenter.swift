//
//  FavoritesPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// Presenter of the Favorites module.
final class FavoritesPresenter {
    
    // MARK: Private Properties
    private let interactor: FavoritesInteractor
    private let router: FavoritesRouter
    private var viewModels: [DetailPointViewModel] = []
    
    // MARK: Public Properties
    weak var view: FavoritesViewProtocol?
    
    // MARK: Initializers
    init(interactor: FavoritesInteractor, router: FavoritesRouter) {
        self.interactor = interactor
        self.router = router
    }
    
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
            view?.showAlert(with: error.localizedDescription)
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
            view?.showAlert(with: "Unable to delete the point")
        }
    }
}
