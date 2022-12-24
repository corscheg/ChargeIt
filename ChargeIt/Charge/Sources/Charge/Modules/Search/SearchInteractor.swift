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
    
    // MARK: VIPER
    weak var presenter: SearchInteractorToPresenterProtocol?
    
    // MARK: Private Properties
    private let networkManager: NetworkManagerProtocol
    private let storageManager: StorageManagerProtocol?
    private let userSettings: UserSettingsProtocol
    private let locationManager: LocationManagerProtocol
    private let geocoder: GeocoderProtocol
    private var locationEnabled = false
    private var parameters: QueryParameters?
    
    // MARK: Initializers
    init(networkManager: NetworkManagerProtocol, storageManager: StorageManagerProtocol?, userSettings: UserSettingsProtocol, locationManager: LocationManagerProtocol, geocoder: GeocoderProtocol) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        self.userSettings = userSettings
        self.locationManager = locationManager
        self.geocoder = geocoder
        super.init()
        
        self.locationManager.distanceFilter = 10
        self.locationManager.delegate = self
    }
    
    // MARK: Private Methods
    private func makeQuery(
        near location: CLLocationCoordinate2D,
        within radius: Int,
        in country: String? = nil,
        usageTypes: [Int]?
    ) {
        let maxCount = userSettings.maxCount().rawValue
        
        networkManager.fetchPoints(latitude: location.latitude, longitude: location.longitude, within: radius, in: country, maxCount: maxCount, usageTypes: usageTypes) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.pointsLoadingFailed(with: error)
            case .success(let points):
                self?.presenter?.pointsLoadingSucceeded(with: points)
            }
            
            // Comment on this line placed in
            // locationManager(_:didUpdateLocations) delegate method.
            self?.locationManager.delegate = self
        }
    }
}

// MARK: - SearchInteractorProtocol
extension SearchInteractor: SearchInteractorProtocol {
    
    func loadNearbyPoints(with options: QueryParameters) {
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
    
    func delete(by id: UUID) throws {
        guard let storageManager else {
            throw StorageError.internalError
        }
        
        try storageManager.delete(by: id)
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
        manager.stopUpdatingLocation()
        
        // The workaround is needed because the method sometimes is called
        // twice after a single request.
        manager.delegate = nil
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
                    self?.makeQuery(near: location.coordinate, within: parameters.radius, usageTypes: usageTypes)
                    return
                }
                
                let countryISO = placemark.isoCountryCode
                
                self?.makeQuery(near: location.coordinate, within: parameters.radius, in: countryISO, usageTypes: usageTypes)
            }
        } else {
            makeQuery(near: location.coordinate, within: parameters.radius, usageTypes: usageTypes)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presenter?.pointsLoadingFailed(with: LocationError.locationError)
    }
}
