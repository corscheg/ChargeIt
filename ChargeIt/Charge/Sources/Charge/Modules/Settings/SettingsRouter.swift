//
//  SettingsRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation
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
        
        let authView = UIViewController()
        let navigationController = UINavigationController(rootViewController: authView)
        uiView.present(navigationController, animated: true)
    }
}
