//
//  SearchInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import CoreLocation

/// Interactor of the Search module.
final class SearchInteractor: NSObject {
    
    // MARK: Public Properties
    weak var presenter: SearchInteractorToPresenterProtocol?
    
    // MARK: Private Properties
    private let dataManager: NetworkManager
    private let locationManager: CLLocationManager
    private let geocoder: CLGeocoder
    private let storageManager = StorageManager.shared
    private var locationEnabled = false
    private var parameters: QueryParametersViewModel?
    
    // MARK: Initializers
    init(dataManager: NetworkManager, locationManager: CLLocationManager, geocoder: CLGeocoder) {
        self.dataManager = dataManager
        self.geocoder = geocoder
        self.locationManager = locationManager
        super.init()
        
        locationManager.delegate = self
    }
    
    // MARK: Private Methods
    private func makeQuery(near location: CLLocationCoordinate2D, within radius: Int, in country: String? = nil, maxCount: Int, usageTypes: [Int]?) {
        dataManager.fetchPoints(near: location, within: radius, in: country, maxCount: maxCount, usageTypes: usageTypes) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.pointsLoadingFailed(with: error)
            case .success(let points):
                self?.presenter?.pointsLoadingSucceeded(with: points)
            }
        }
    }
}

// MARK: - SearchInteractorProtocol
extension SearchInteractor: SearchInteractorProtocol {
    
    func loadNearbyPoints(with options: QueryParametersViewModel) {
        guard locationEnabled else {
            presenter?.pointsLoadingFailed(with: LocationError.locationPermissionNotGranted)
            return
        }
        parameters = options
        locationManager.requestLocation()
    }
    
    func store(point: ChargingPoint) throws {
        guard let storageManager else {
            throw StorageError.internalError
        }
        try storageManager.add(point: point)
    }
    
    @discardableResult
    func delete(by id: UUID) throws -> Bool {
        guard let storageManager else {
            throw StorageError.internalError
        }
        
        let result = try storageManager.delete(by: id)
        
        return result
    }
    
    func isFavorite(by id: UUID) throws -> Bool {
        guard let storageManager else {
            throw StorageError.internalError
        }
        
        let result = try storageManager.isFavorite(by: id)
        
        return result
    }
}

// MARK: - CLLocationManagerDelegate
extension SearchInteractor: CLLocationManagerDelegate {
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manageAuthorization(status: manager.authorizationStatus)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manageAuthorization(status: status)
    }
    
    private func manageAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationEnabled = true
            presenter?.enableLocation()
        case .denied, .restricted:
            locationEnabled = false
            presenter?.disableLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            presenter?.pointsLoadingFailed(with: LocationError.locationError)
            return
        }
        
        guard let parameters else {
            presenter?.pointsLoadingFailed(with: NetworkingError.invalidURL)
            return
        }
        
        var usageTypes: [Int]? = nil
        
        if parameters.publicOnly {
            usageTypes = [1, 4, 7, 5]
        }
        
        if parameters.currentCountryOnly {
            
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                guard error == nil, let placemark = placemarks?.first else {
                    self?.makeQuery(near: location.coordinate, within: parameters.radius, maxCount: 10_000, usageTypes: usageTypes)
                    return
                }
                
                let countryISO = placemark.isoCountryCode
                
                self?.makeQuery(near: location.coordinate, within: parameters.radius, in: countryISO, maxCount: 10_000, usageTypes: usageTypes)
            }
        } else {
            makeQuery(near: location.coordinate, within: parameters.radius, maxCount: 10_000, usageTypes: usageTypes)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presenter?.pointsLoadingFailed(with: LocationError.locationError)
    }
}
