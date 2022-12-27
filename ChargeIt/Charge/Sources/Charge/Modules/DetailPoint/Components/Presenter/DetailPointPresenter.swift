//
//  DetailPointPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// Presenter of the Detail Point module.
final class DetailPointPresenter {
    
    // MARK: VIPER
    private let interactor: DetailPointInteractorProtocol
    private let router: DetailPointRouterProtocol
    weak var view: DetailPointViewProtocol?
    
    // MARK: Private Properties
    private var viewModel: DetailPointViewModel
    private var isFavorite: Bool = false
    
    // MARK: Initializers
    init(router: DetailPointRouterProtocol, interactor: DetailPointInteractorProtocol, viewModel: DetailPointViewModel) {
        self.router = router
        self.interactor = interactor
        self.viewModel = viewModel
    }
    
}

// MARK: - DetailPointViewToPresenterProtocol
extension DetailPointPresenter: DetailPointViewToPresenterProtocol {
    
    func viewDidLoad() {
        view?.updateUI(with: viewModel)
        do {
            isFavorite = try interactor.isFavorite(by: viewModel.uuid)
            view?.setFavorite(state: isFavorite)
        } catch {
            presentStorageError()
        }
    }
    
    func favoriteButtonTapped() {
        do {
            try viewModel.didTapFavoriteButton(isFavorite)
            isFavorite.toggle()
            view?.setFavorite(state: isFavorite)
        } catch {
            presentStorageError()
        }
    }
    
    func openMapsButtonTapped() {
        router.openInMaps(latitude: viewModel.latitude, longitude: viewModel.longitude)
    }
    
    func dismissButtonTapped() {
        router.dismiss()
    }
    
    func checkInTapped() {
        view?.startActivityIndication()
        let checkIn = CheckIn(pointID: viewModel.id)
        interactor.checkIn(checkIn)
    }
    
    private func presentStorageError() {
        view?.showErrorAlert(with: "Unable to access storage")
    }
}

// MARK: - DetailPointInteractorToPresenterProtocol
extension DetailPointPresenter: DetailPointInteractorToPresenterProtocol {
    
    func checkInSucceeded() {
        DispatchQueue.main.async {
            self.view?.stopActivityIndication()
            self.view?.showSuccessAlert(with: "Check-In succeded!")
        }
    }
    
    func checkInFailed(with error: LocalizedError) {
        DispatchQueue.main.async {
            self.view?.stopActivityIndication()
            
            let message: String
            
            if let authError = error as? AuthError {
                message = authError.localizedDescription
            } else {
                message = "Check-In failed"
            }
            self.view?.showErrorAlert(with: message)
        }
    }
}
