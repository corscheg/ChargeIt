//
//  DetailPointPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// Presenter of the Detail Point module.
class DetailPointPresenter {
    
    // MARK: Public Properties
    weak var view: DetailPointViewProtocol?
    
    // MARK: Private Properties
    private let router: DetailPointRouterProtocol
    private let interactor: DetailPointInteractorProtocol
    private let point: ChargingPoint
    
    // MARK: Initializers
    init(router: DetailPointRouterProtocol, interactor: DetailPointInteractorProtocol, point: ChargingPoint) {
        self.router = router
        self.interactor = interactor
        self.point = point
    }
    
}

// MARK: - DetailPointPresenterProtocol
extension DetailPointPresenter: DetailPointPresenterProtocol {
    func askForUpdate() {
        view?.updateUI(with: DetailPointViewModel(description: point.description))
    }
}
