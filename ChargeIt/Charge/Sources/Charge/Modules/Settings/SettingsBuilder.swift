//
//  SettingsBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// Use this struct to build the Favorites module.
struct SettingsBuilder {
    // MARK: Static Methods
    /// Build the module.
    static func build() -> SettingsViewController {
        let interactor = SettingsInteractor()
        let router = SettingsRouter()
        let presenter = SettingsPresenter(router: router, interactor: interactor)
        let view = SettingsViewController(presenter: presenter)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
