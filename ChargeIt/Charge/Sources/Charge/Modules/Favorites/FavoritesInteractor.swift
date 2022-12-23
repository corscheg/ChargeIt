//
//  FavoritesInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// Interactor of the Favorites module.
final class FavoritesInteractor {
    
    // MARK: VIPER
    weak var presenter: FavoritesPresenterProtocol?
    
    // MARK: Private Properties
    private let storageManager: StorageManager?
    
    // MARK: Initializers
    init(storageManager: StorageManager?) {
        self.storageManager = storageManager
    }
}

// MARK: - FavoritesInteractorProtocol
extension FavoritesInteractor: FavoritesInteractorProtocol {
    func allFavorites() throws -> [PointObj] {
        guard let storageManager else {
            throw StorageError.internalError
        }
        
        return try storageManager.allPoints()
    }
    
    func deletePoint(by id: UUID) throws {
        guard let storageManager else {
            throw StorageError.internalError
        }
        
        try storageManager.delete(by: id)
    }
}
