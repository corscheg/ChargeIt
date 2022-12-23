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
    func requestAllDelete() {
        view?.presentConfirmationDialog()
    }
    
    func deletionConfirmed() {
        do {
            try interactor.deleteAll()
            view?.showSuccessAlert(with: "Favorites cleared")
        } catch {
            view?.showErrorAlert(with: "Storage error occurred")
        }
        hideAlertAfterDelay()
    }
    
    private func hideAlertAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.view?.hideAlert()
        }
    }
}
