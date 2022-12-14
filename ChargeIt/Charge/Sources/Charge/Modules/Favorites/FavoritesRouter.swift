//
//  FavoritesRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// Router of the Favorites module.
final class FavoritesRouter {
    
    // MARK: Public Properties
    weak var view: FavoritesViewProtocol?
}

// MARK: - FavoritesRouterProtocol
extension FavoritesRouter: FavoritesRouterProtocol {
    
}
