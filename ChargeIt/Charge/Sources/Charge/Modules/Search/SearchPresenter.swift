//
//  SearchPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import MapKit

/// Presenter of the Search module.
final class SearchPresenter {
    
    // MARK: Public Properties
    weak var view: SearchViewProtocol?
    
    // MARK: Private Properties
    private let router: SearchRouterProtocol
    private let interactor: SearchInteractorProtocol
    private var viewModel: SearchViewModel = SearchViewModel(
        locations: [],
        region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
        ),
        radius: 9,
        maxCount: 10000
    )
    private var points: [ChargingPoint] = []
    
    // MARK: Initializers
    init(router: SearchRouterProtocol, interactor: SearchInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
    
    func loadState() {
        view?.updateUI(with: viewModel)
    }
    
    func radiusChanged(value: Float) {
        viewModel.radius = Int(pow(value, 2))
        view?.updateParameters(with: viewModel)
    }
    
    func mapRegionChanged(to value: MKCoordinateRegion) {
        viewModel.region = value
    }
    
    func loadNearbyPoints() {
        view?.startActivityIndication()
        let parameters = SearchQueryParameters(radius: viewModel.radius, maxCount: viewModel.maxCount)
        interactor.loadNearbyPoints(with: parameters)
    }
    
    func pointsLoadingFailed(with error: SearchError) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(with: error.localizedDescription)
            self?.view?.stopActivityIndication()
        }
    }
    
    func pointsLoadingSucceeded(with points: [ChargingPoint]) {
        
        var minLatitude = 90.0
        var minLongitude = 180.0
        var maxLatitude = -90.0
        var maxLongitude = -180.0
        
        viewModel.locations = []
        
        points.forEach {
            let coordinates = $0.location.coordinates
            viewModel.locations.append(coordinates)
            
            minLatitude = min(minLatitude, coordinates.latitude)
            minLongitude = min(minLongitude, coordinates.longitude)
            maxLatitude = max(maxLatitude, coordinates.latitude)
            maxLongitude = max(maxLongitude, coordinates.longitude)
        }
        
        let center = CLLocationCoordinate2D(latitude: (maxLatitude + minLatitude) / 2, longitude: (maxLongitude + minLongitude) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLatitude - minLatitude) * 1.1, longitudeDelta: (maxLongitude - minLongitude) * 1.3)
        
        viewModel.region = MKCoordinateRegion(center: center, span: span)
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.updateUI(with: self!.viewModel)
            self?.view?.stopActivityIndication()
            self?.points = points
        }
    }
    
    func enableLocation() {
        view?.setLocation(enabled: true)
    }
    
    func disableLocation() {
        view?.setLocation(enabled: false)
    }
    
    func itemTapped(at index: Int) {
        let item = points[index]
        
        let connections = item.connections.map {
            DetailPointViewModel.ConnectionViewModel(
                type: $0.type.title,
                level: $0.level?.title,
                fastChargeCapable: $0.level?.fastChargeCapable,
                current: $0.currentType?.id == 30 ? "DC" : "AC"
            )
        }
        
        var urls: [URL] = []
        
        if let medias = item.mediaItems {
            urls = medias.map {
                $0.url
            }
        }
        
        let detailViewModel = DetailPointViewModel(
            country: item.location.country.code,
            state: item.location.state,
            town: item.location.town,
            addressFirst: item.location.addressFirst,
            addressSecond: item.location.addressSecond,
            locationTitle: item.location.title,
            connections: connections,
            imageURLs: urls
        )
        
        router.presentDetail(with: detailViewModel)
    }
}
