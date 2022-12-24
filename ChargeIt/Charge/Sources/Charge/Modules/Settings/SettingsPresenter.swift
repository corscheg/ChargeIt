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
    private var viewModel = SettingsViewModel(maxCountSelectedIndex: 2)
    
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
        case 100:
            newIndex = 0
        case 1000:
            newIndex = 1
        case 10000:
            newIndex = 3
        default:
            newIndex = 2
        }
        
        viewModel = SettingsViewModel(maxCountSelectedIndex: newIndex)
        
        view?.updateUI(with: viewModel)
    }
    
    func clearFavoritesTapped() {
        view?.presentConfirmationDialog()
    }
    
    func deletionConfirmed() {
        do {
            try interactor.deleteAll()
            view?.showSuccessAlert(with: "Favorites cleared")
        } catch {
            view?.showErrorAlert(with: "Storage error occurred")
        }
    }
    
    func maxCountSettingIndexChanged(to index: Int) {
        let maxCount: Int
        switch index {
        case 0:
            maxCount = 100
        case 1:
            maxCount = 1000
        case 2:
            maxCount = 5000
        case 3:
            maxCount = 10000
        default:
            return
        }
        
        interactor.setNewMaxCount(maxCount)
    }
}
