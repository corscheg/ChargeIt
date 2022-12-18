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
    private var storageManager = StorageManager.shared
}

// MARK: - DetailPointInteractorProtocol
extension DetailPointInteractor: DetailPointInteractorProtocol {
    func isFavorite(by id: UUID) throws -> Bool {
        guard let storageManager else {
            throw StorageError.internalError
        }
        
        return try storageManager.isFavorite(by: id)
    }
}
