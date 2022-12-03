//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import MapKit

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
        
        var minLatitude = 90.0
        var minLongitude = 180.0
        var maxLatitude = -90.0
        var maxLongitude = -180.0
        
        points.forEach {
            let coordinates = $0.location.coordinates
            viewModel.locations.append(coordinates)
            
            minLatitude = min(minLatitude, coordinates.latitude)
            minLongitude = min(minLongitude, coordinates.longitude)
            maxLatitude = max(maxLatitude, coordinates.latitude)
            maxLongitude = max(maxLongitude, coordinates.longitude)
        }
        
        let center = CLLocationCoordinate2D(latitude: (maxLatitude + minLatitude) / 2, longitude: (maxLongitude + minLongitude) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLatitude - minLatitude) * 1.1, longitudeDelta: (maxLongitude - minLongitude) * 1.1)
        
        viewModel.region = MKCoordinateRegion(center: center, span: span)
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.updateUI(with: viewModel)
        }
    }
}
