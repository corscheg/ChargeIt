//
//  DetailPointInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// Interactor of the Detail Point module.
final class DetailPointInteractor {
    
    // MARK: VIPER
    weak var presenter: DetailPointInteractorToPresenterProtocol?
    
    // MARK: Private Properties
    private let storageManager: StorageManagerProtocol?
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    
    // MARK: Initializers
    init(storageManager: StorageManagerProtocol?, networkManager: NetworkManagerProtocol, keychainManager: KeychainManagerProtocol) {
        self.storageManager = storageManager
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }
}

// MARK: - DetailPointInteractorProtocol
extension DetailPointInteractor: DetailPointInteractorProtocol {
    func isFavorite(by id: UUID) throws -> Bool {
        guard let storageManager else {
            throw StorageError.internalError
        }
        
        return try storageManager.isFavorite(by: id)
    }
    
    func checkIn(_ check: CheckIn) {
        guard let token = try? keychainManager.loadToken() else {
            presenter?.checkInFailed(with: AuthError.notAuthorized)
            return
        }
        networkManager.checkIn(check, token: token) { [weak self] result in
            
            switch result {
            case .success(let response):
                if response.status == "OK" && response.description == "OK" {
                    self?.presenter?.checkInSucceeded()
                } else {
                    self?.presenter?.checkInFailed(with: NetworkingError.badResponse)
                }
            case .failure(let error):
                self?.presenter?.checkInFailed(with: error)
            }
        }
    }
}
