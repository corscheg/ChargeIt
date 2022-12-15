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
    
    // MARK: Public Properties
    weak var view: FavoritesViewProtocol?
    
    // MARK: Initializers
    init(interactor: FavoritesInteractor, router: FavoritesRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - FavoritesPresenterProtocol
extension FavoritesPresenter: FavoritesPresenterProtocol {
    func viewDidLoad() {
        
    }
}
