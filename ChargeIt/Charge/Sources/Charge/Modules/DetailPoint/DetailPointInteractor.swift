//
//  DetailPointInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// Interactor of the Detail Point module.
final class DetailPointInteractor {
    
    // MARK: Public Properties
    weak var presenter: DetailPointPresenterProtocol?
    
    // MARK: Private Properties
    private let dataManager: DataManager = DataManager.shared
    private let storageManager: StorageManager = StorageManager.shared
}

// MARK: - DetailPointInteractorProtocol
extension DetailPointInteractor: DetailPointInteractorProtocol {
    
    func isFavorite(by id: UUID) -> Bool {
        storageManager.isFavorite(by: id)
    }
    
    func addToFavorites(_ point: DetailPointViewModel) {
        storageManager.add(point: point)
    }
    
    func removeFromFavorites(by id: UUID) {
        storageManager.delete(by: id)
    }
}
