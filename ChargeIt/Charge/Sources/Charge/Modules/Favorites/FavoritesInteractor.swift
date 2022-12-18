//
//  FavoritesInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// Interactor of the Favorites module.
final class FavoritesInteractor {
    
    // MARK: Private Properties
    private let storageManager = StorageManager.shared
    
    // MARK: Public Properties
    weak var presenter: FavoritesPresenterProtocol?
}

// MARK: - FavoritesInteractorProtocol
extension FavoritesInteractor: FavoritesInteractorProtocol {
    
}
