//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

class SearchPresenter {
    
    // MARK: Public Properties
    weak var view: SearchViewProtocol?
    
    // MARK: Private Properties
    private let router: SearchRouterProtocol
    private let interactor: SearchInteractorProtocol
    
    // MARK: Initializers
    init(router: SearchRouterProtocol, interactor: SearchInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
    
    func loadPoints() {
        interactor.loadPoints()
    }
    
    func pointsLoadingFailed(with error: Error) {
        view?.showError(with: error.localizedDescription)
    }
    
    func pointsLoadingSucceeded(with points: [ChargingPoint]) {
        var viewModel = SearchViewModel()
        
        points.forEach {
            viewModel.locations.append($0.location.coordinates)
        }
        
        view?.updateUI(with: viewModel)
    }
}
