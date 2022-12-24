//
//  SettingsBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation
import UIKit

/// Use this struct to build the Favorites module.
struct SettingsBuilder {
    // MARK: Static Methods
    /// Build the module.
    static func build() -> SettingsViewController {
        let storageManager = StorageManager.shared
        let userSettings = UserSettings.shared
        let hapticsGenerator = UINotificationFeedbackGenerator()
        
        let interactor = SettingsInteractor(storageManager: storageManager, userSettings: userSettings)
        let router = SettingsRouter()
        let presenter = SettingsPresenter(router: router, interactor: interactor)
        let view = SettingsViewController(presenter: presenter, hapticsGenerator: hapticsGenerator)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
