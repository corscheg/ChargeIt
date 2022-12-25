//
//  AuthInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// Interactor of the Auth module.
final class AuthInteractor {
    
    // MARK: VIPER
    weak var presenter: AuthInteractorToPresenterProtocol?
    
    // MARK: Private Properties
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    
    // MARK: Initializers
    init(networkManager: NetworkManagerProtocol, keychainManager: KeychainManagerProtocol) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }
}

// MARK: - AuthInteractorProtocol
extension AuthInteractor: AuthInteractorProtocol {
    
    func authorize(_ credentials: Credentials) {
        networkManager.authenticate(credentials) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.authFailed(with: error)
            case .success(let response):
                let token = response.tokenWrapper.token
                
                do {
                    try self?.keychainManager.save(token: token)
                    self?.presenter?.authSucceeded()
                } catch {
                    self?.presenter?.authFailed(with: error)
                }
            }
        }
    }
}
