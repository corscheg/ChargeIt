//
//  SettingsPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// Presenter of the Settings module.
final class SettingsPresenter {
    
    // MARK: Private Properties
    private let router: SettingsRouterProtocol
    private let interactor: SettingsInteractorProtocol
    
    // MARK: Public Properties
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
