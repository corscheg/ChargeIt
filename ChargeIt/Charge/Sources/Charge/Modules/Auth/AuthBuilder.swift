//
//  AuthBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// Use this struct to build the Auth module.
struct AuthBuilder {
    
    // MARK: Static Methods
    /// Build the module.
    static func build() -> AuthViewController {
        let interactor = AuthInteractor()
        let router = AuthRouter()
        let presenter = AuthPresenter(interactor: interactor, router: router)
        let view = AuthViewController(presenter: presenter)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
