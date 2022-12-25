//
//  AuthRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation
import UIKit

/// Router of the Auth module.
final class AuthRouter {
    
    // MARK: VIPER
    weak var view: AuthViewProtocol?
}

// MARK: - AuthRouterProtocol
extension AuthRouter: AuthRouterProtocol {
    func dismiss() {
        guard let uiView = view as? UIViewController else {
            return
        }
        
        uiView.dismiss(animated: true)
    }
}
