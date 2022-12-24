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
    
    // MARK: Initializers
    init(storageManager: StorageManagerProtocol?, userSettings: UserSettingsProtocol) {
        self.storageManager = storageManager
        self.userSettings = userSettings
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
    
    func maxCount() -> Int {
        userSettings.maxCount()
    }
    
    func setNewMaxCount(_ maxCount: Int) {
        userSettings.updateMaxCount(to: maxCount)
    }
}
