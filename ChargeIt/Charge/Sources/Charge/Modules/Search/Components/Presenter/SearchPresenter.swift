//
//  SearchPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import MapKit

/// Presenter of the Search module.
final class SearchPresenter {
    
    // MARK: VIPER
    private let interactor: SearchInteractorProtocol
    private let router: SearchRouterProtocol
    weak var view: SearchViewProtocol?
    
    // MARK: Private Properties
    private var viewModel: SearchViewModel = SearchViewModel(
        locations: [],
        region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
        )
    )
    private var queryParameters = QueryParameters(radius: 9, currentCountryOnly: false, publicOnly: true)
    private var points: [ChargingPoint] = []
    
    // MARK: Initializers
    init(router: SearchRouterProtocol, interactor: SearchInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - SearchViewToPresenterProtocol
extension SearchPresenter: SearchViewToPresenterProtocol {    
    
    func viewDidLoad() {
        view?.updateUI(with: viewModel)
        view?.updateRadius(with: queryParameters.radius)
    }
    
    func radiusChanged(value: Float) {
        queryParameters.radius = Int(pow(value, 2))
        view?.updateRadius(with: queryParameters.radius)
    }
    
    func countryRestrictionIndexChanged(to newValue: Int) {
        switch newValue {
        case 0:
            queryParameters.currentCountryOnly = false
        default:
            queryParameters.currentCountryOnly = true
        }
    }
    
    func usageTypeIndexChanged(to newValue: Int) {
        switch newValue {
        case 0:
            queryParameters.publicOnly = true
        default:
            queryParameters.publicOnly = false
        }
    }
    
    func mapRegionChanged(to value: MKCoordinateRegion) {
        viewModel.region = value
    }
    
    func loadNearbyPoints() {
        view?.startActivityIndication()
        view?.lockRequests()
        interactor.loadNearbyPoints(with: queryParameters)
    }
    
    func itemTapped(at index: Int) {
        let item = points[index]
        
        let detailViewModel = Converter().makeViewModel(from: item) { [weak self, uuid = item.uuid, index] isFavoriteNow in // didTapButton closure
            guard let self else {
                return
            }
            
            if isFavoriteNow {
                try self.interactor.delete(by: uuid)
            } else {
                let point = self.points[index]
                try self.interactor.store(point: point)
            }
        }
        
        router.presentDetail(with: detailViewModel)
    }
}

// MARK: - SearchInteractorToPresenterProtocol
extension SearchPresenter: SearchInteractorToPresenterProtocol {
    func pointsLoadingFailed(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showErrorAlert(with: error.localizedDescription)
            self?.view?.unlockRequests()
            self?.view?.stopActivityIndication()
        }
    }
    
    func pointsLoadingSucceeded(with points: [ChargingPoint]) {
        
        // Server may return duplicate values
        // It's necessary to remove duplicates
        // With determined UUID selection rule
        
        var pointSet = Set<ChargingPoint>()
        for newPoint in points {
            guard let index = pointSet.firstIndex(of: newPoint) else {
                pointSet.insert(newPoint)
                continue
            }
            
            let oldPoint = pointSet[index]
            
            if newPoint.uuid.uuidString < oldPoint.uuid.uuidString {
                pointSet.update(with: newPoint)
            }
        }
        
        let pointArray = Array(pointSet)
        
        var minLatitude = 90.0
        var minLongitude = 180.0
        var maxLatitude = -90.0
        var maxLongitude = -180.0
        
        viewModel.locations = []
        
        pointArray.forEach {
            let coordinates = CLLocationCoordinate2D(latitude: $0.location.latitude, longitude: $0.location.longitude)
            viewModel.locations.append(coordinates)
            
            minLatitude = min(minLatitude, coordinates.latitude)
            minLongitude = min(minLongitude, coordinates.longitude)
            maxLatitude = max(maxLatitude, coordinates.latitude)
            maxLongitude = max(maxLongitude, coordinates.longitude)
        }
        
        let center = CLLocationCoordinate2D(latitude: (maxLatitude + minLatitude) / 2, longitude: (maxLongitude + minLongitude) / 2)
        let span = MKCoordinateSpan(latitudeDelta: max((maxLatitude - minLatitude) * 1.1, 0.1), longitudeDelta: max((maxLongitude - minLongitude) * 1.3, 0.1))
        
        viewModel.region = MKCoordinateRegion(center: center, span: span)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            self.view?.updateUI(with: self.viewModel)
            self.view?.stopActivityIndication()
            self.view?.unlockRequests()
            self.points = pointArray
        }
    }
    
    func enableLocation() {
        view?.setLocation(enabled: true)
    }
    
    func disableLocation() {
        view?.setLocation(enabled: false)
    }
}
