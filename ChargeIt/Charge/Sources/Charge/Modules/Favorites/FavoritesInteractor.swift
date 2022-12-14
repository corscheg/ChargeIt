//
//  FavoritesInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// Interactor of the Favorites module.
final class FavoritesInteractor {
    
    // MARK: Public Properties
    weak var presenter: FavoritesPresenterProtocol?
}

// MARK: - FavoritesInteractorProtocol
extension FavoritesInteractor: FavoritesInteractorProtocol {
    
}
