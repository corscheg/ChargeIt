//
//  SettingsRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// Router of the Settings module.
final class SettingsRouter {
    
    // MARK: VIPER
    weak var view: SettingsViewProtocol?
}

// MARK: - SettingsRouterProtocol
extension SettingsRouter: SettingsRouterProtocol {
    
}
