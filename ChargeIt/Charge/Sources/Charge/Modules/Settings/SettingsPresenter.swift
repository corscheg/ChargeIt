//
//  SettingsPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// Presenter of the Settings module.
final class SettingsPresenter {
    
    // MARK: VIPER
    private let interactor: SettingsInteractorProtocol
    private let router: SettingsRouterProtocol
    weak var view: SettingsViewProtocol?
    
    // MARK: Initializers
    init(router: SettingsRouterProtocol, interactor: SettingsInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - SettingsPresenterProtocol
extension SettingsPresenter: SettingsPresenterProtocol {
    
}
