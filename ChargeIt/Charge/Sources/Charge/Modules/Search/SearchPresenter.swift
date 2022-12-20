//
//  SearchPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import MapKit
import CoreData

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
        )
    )
    private var queryParameters = QueryParametersViewModel(radius: 9, currentCountryOnly: false)
    private var points: [ChargingPoint] = []
    
    // MARK: Initializers
    init(router: SearchRouterProtocol, interactor: SearchInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
    
    func viewDidLoad() {
        view?.updateUI(with: viewModel)
        view?.updateParameters(with: queryParameters)
    }
    
    func radiusChanged(value: Float) {
        queryParameters.radius = Int(pow(value, 2))
        view?.updateParameters(with: queryParameters)
    }
    
    func mapRegionChanged(to value: MKCoordinateRegion) {
        viewModel.region = value
    }
    
    func loadNearbyPoints() {
        view?.startActivityIndication()
        interactor.loadNearbyPoints(with: queryParameters)
    }
    
    func pointsLoadingFailed(with error: SearchError) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(with: error.localizedDescription)
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
            
            if newPoint.id.uuidString < oldPoint.id.uuidString {
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
            let coordinates = $0.location.coordinates
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
            self.points = pointArray
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
            let current: Current
            
            switch $0.currentType?.id {
            case 10, 20:
                current = .ac
            case 30:
                current = .dc
            default:
                current = .unknown
            }
            
            return DetailPointViewModel.ConnectionViewModel(
                type: $0.type.title,
                level: $0.level?.title,
                fastChargeCapable: $0.level?.fastChargeCapable,
                current: current
            )
        }
        
        var urls: [URL] = []
        
        if let medias = item.mediaItems {
            urls = medias.map {
                $0.url
            }
        }
        
        var approximateLocation = ""
        
        if let town = item.location.town {
            approximateLocation.append("\(town), ")
        }
        
        if let state = item.location.state {
            approximateLocation.append("\(state), ")
        }
        
        approximateLocation.append(item.location.country.code)
        
        guard let isItemFavorite = try? interactor.isFavorite(by: item.id) else {
            view?.showError(with: "Unable to load Storage")
            return
        }
        
        let detailViewModel = DetailPointViewModel(
            id: item.id,
            approximateLocation: approximateLocation,
            addressFirst: item.location.addressFirst,
            addressSecond: item.location.addressSecond,
            locationTitle: item.location.title,
            connections: connections,
            imageURLs: urls,
            latitude: item.location.coordinates.latitude,
            longitude: item.location.coordinates.longitude,
            isFavorite: isItemFavorite
        ) { [weak self, id = item.id, index] isFavoriteNow in // didTapButton closure
            guard let self else {
                return
            }
            
            if isFavoriteNow {
                try self.interactor.delete(by: id)
            } else {
                let point = self.points[index]
                try self.interactor.store(point: point)
            }
        }
        
        router.presentDetail(with: detailViewModel)
    }
}
