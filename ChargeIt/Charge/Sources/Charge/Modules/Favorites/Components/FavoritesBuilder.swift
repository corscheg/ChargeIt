//
//  FavoritesBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import UIKit

/// Use this struct to build the Favorites module.
struct FavoritesBuilder {
    // MARK: Static Methods
    /// Build the module.
    static func build() -> FavoritesViewController {
        let storageManager = StorageManager.shared
        let hapticsGenerator = UINotificationFeedbackGenerator()
        
        let interactor = FavoritesInteractor(storageManager: storageManager)
        let router = FavoritesRouter()
        let presenter = FavoritesPresenter(interactor: interactor, router: router)
        let view = FavoritesViewController(presenter: presenter, hapticsGenerator: hapticsGenerator)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
