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
    
    // MARK: Private Properties
    private var viewModel = SettingsViewModel(maxCountSelectedIndex: 2, authorized: false)
    
    // MARK: Initializers
    init(router: SettingsRouterProtocol, interactor: SettingsInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - SettingsPresenterProtocol
extension SettingsPresenter: SettingsPresenterProtocol {
    func viewDidAppear() {
        let maxCount = interactor.maxCount()
        let newIndex: Int
        
        switch maxCount {
        case .oneHundred:
            newIndex = 0
        case .oneThousand:
            newIndex = 1
        case .fiveThousand:
            newIndex = 2
        case .tenThousand:
            newIndex = 3
        }
        
        let authorized: Bool
        
        do {
            authorized = try interactor.isAuthorized()
        } catch {
            view?.showErrorAlert(with: error.localizedDescription)
            authorized = false
        }
        
        viewModel = SettingsViewModel(maxCountSelectedIndex: newIndex, authorized: authorized)
        
        view?.updateUI(with: viewModel)
    }
    
    func clearFavoritesTapped() {
        view?.presentDeletionConfirmationDialog()
    }
    
    func deletionConfirmed() {
        do {
            try interactor.deleteAll()
            view?.showSuccessAlert(with: "Favorites cleared")
        } catch {
            view?.showErrorAlert(with: "Storage error occurred")
        }
    }
    
    func signOutConfirmed() {
        do {
            try interactor.signOut()
            viewModel = SettingsViewModel(maxCountSelectedIndex: viewModel.maxCountSelectedIndex, authorized: false)
            view?.updateUI(with: viewModel)
        } catch {
            view?.showErrorAlert(with: error.localizedDescription)
        }
    }
    
    func maxCountSettingIndexChanged(to index: Int) {
        let maxCount: MaxCount
        switch index {
        case 0:
            maxCount = .oneHundred
        case 1:
            maxCount = .oneThousand
        case 2:
            maxCount = .fiveThousand
        case 3:
            maxCount = .tenThousand
        default:
            return
        }
        
        interactor.setNewMaxCount(maxCount)
    }
    
    func authButtonTapped() {
        if viewModel.authorized {
            view?.presentSignOutConfirmationDialog()
        } else {
            router.revealAuthScreen()
        }
    }
}
