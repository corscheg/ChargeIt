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
        
        var approximateLocation = ""
        
        if let town = item.location.town {
            approximateLocation.append("\(town), ")
        }
        
        if let state = item.location.state {
            approximateLocation.append("\(state), ")
        }
        
        approximateLocation.append(item.location.country.code)
        
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
            isFavorite: interactor.isFavorite(by: item.id)
        ) { [weak self, id = item.id, index] isFavoriteActually in
            guard let self else {
                return false
            }
            
            if isFavoriteActually {
                let result = self.interactor.delete(by: id)
                return result
            } else {
                let pointObj: PointObj = PointObj(context: self.interactor.storageContext)
                let point = self.points[index]
                
                pointObj.id = point.id
                pointObj.addressFirst = point.location.addressFirst
                pointObj.addressSecond = point.location.addressSecond
                pointObj.town = point.location.town
                pointObj.state = point.location.state
                pointObj.country = point.location.country.code
                pointObj.latitude = point.location.coordinates.latitude
                pointObj.longitude = point.location.coordinates.longitude
                pointObj.locationTitle = point.location.title
                
                point.connections.forEach {
                    let connectionObj = ConnectionObj(context: self.interactor.storageContext)
                    connectionObj.type = $0.type.title
                    connectionObj.level = $0.level?.title
                    connectionObj.fastChargeCapable = $0.level?.fastChargeCapable ?? false
                    connectionObj.current = $0.currentType?.title

                    pointObj.addToConnections(connectionObj)
                }
                
                point.mediaItems?.forEach {
                    let urlObj = URLsObj(context: self.interactor.storageContext)
                    urlObj.url = $0.url

                    pointObj.addToUrls(urlObj)
                }
                
                let result = self.interactor.store()
                return result
            }
        }
        
        router.presentDetail(with: detailViewModel)
    }
}
