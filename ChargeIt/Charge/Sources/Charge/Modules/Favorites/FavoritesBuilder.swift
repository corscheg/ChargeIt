//
//  FavoritesBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// Use this struct to build the Favorites module.
struct FavoritesBuilder {
    // MARK: Static Methods
    /// Build the module.
    static func build() -> FavoritesViewController {
        let interactor = FavoritesInteractor(storageManager: StorageManager.shared)
        let router = FavoritesRouter()
        let presenter = FavoritesPresenter(interactor: interactor, router: router)
        let view = FavoritesViewController(presenter: presenter)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
