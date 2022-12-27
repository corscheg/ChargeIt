//
//  AuthPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// Presenter of the Auth module.
final class AuthPresenter {
    
    // MARK: VIPER
    private let interactor: AuthInteractorProtocol
    private let router: AuthRouterProtocol
    weak var view: AuthViewProtocol?
    
    // MARK: Private Properties
    private var email = ""
    private var password = ""
    
    // MARK: Initializers
    init(interactor: AuthInteractorProtocol, router: AuthRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - AuthViewToPresenterProtocol
extension AuthPresenter: AuthViewToPresenterProtocol {
    func emailChanged(to value: String) {
        email = value
    }
    
    func passwordChanged(to value: String) {
        password = value
    }
    
    func authTapped() {
        view?.startActivityIndication()
        let credentials = Credentials(email: email, password: password)
        interactor.authorize(credentials)
    }
    
    func dismissTapped() {
        router.dismiss()
    }
}

// MARK: - AuthInteractorToPresenterProtocol
extension AuthPresenter: AuthInteractorToPresenterProtocol {
    func authSucceeded() {
        DispatchQueue.main.async {
            self.view?.stopActivityIndication()
            self.view?.showSuccessAlert(with: "Authentication successful!")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.router.dismiss()
        }
    }
    
    func authFailed(with error: Error) {
        let message: String
        
        if error is KeychainError {
            message = "Internal password storage error"
        } else {
            message = "Authentication falied"
        }
        
        DispatchQueue.main.async {
            self.view?.stopActivityIndication()
            self.view?.showErrorAlert(with: message)
        }
    }
}
