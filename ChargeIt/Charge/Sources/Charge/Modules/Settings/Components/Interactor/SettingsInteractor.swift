//
//  SettingsInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// Interactor of the Search module.
final class SettingsInteractor {
    
    // MARK: VIPER
    weak var presenter: SettingsPresenterProtocol?
    
    // MARK: Private Properties
    private let storageManager: StorageManagerProtocol?
    private let userSettings: UserSettingsProtocol
    private let keychainManager: KeychainManagerProtocol
    
    // MARK: Initializers
    init(storageManager: StorageManagerProtocol?, userSettings: UserSettingsProtocol, keychainManager: KeychainManagerProtocol) {
        self.storageManager = storageManager
        self.userSettings = userSettings
        self.keychainManager = keychainManager
    }
}

// MARK: - SettingsInteractorProtocol
extension SettingsInteractor: SettingsInteractorProtocol {
    func deleteAll() throws {
        guard let storageManager else {
            throw StorageError.internalError
        }
        
        try storageManager.deleteAll()
    }
    
    func maxCount() -> MaxCount {
        userSettings.maxCount()
    }
    
    func setNewMaxCount(_ maxCount: MaxCount) {
        userSettings.updateMaxCount(to: maxCount)
    }
    
    func isAuthorized() throws -> Bool {
        try keychainManager.loadToken() != nil
    }
    
    func signOut() throws {
        try keychainManager.deleteToken()
    }
}
