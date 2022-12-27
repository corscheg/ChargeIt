//
//  SettingsRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit

/// Router of the Settings module.
final class SettingsRouter {
    
    // MARK: VIPER
    weak var view: SettingsViewProtocol?
}

// MARK: - SettingsRouterProtocol
extension SettingsRouter: SettingsRouterProtocol {
    
    func revealAuthScreen() {
        guard let uiView = view as? UIViewController else {
            return
        }
        
        let authView = AuthBuilder.build()
        let navigationController = UINavigationController(rootViewController: authView)
        navigationController.modalPresentationStyle = .fullScreen
        uiView.present(navigationController, animated: true)
    }
}
