//
//  SearchInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import CoreLocation
import CoreData

/// Interactor of the Search module.
final class SearchInteractor: NSObject {
    
    // MARK: Public Properties
    weak var presenter: SearchPresenterProtocol?
    
    // MARK: Private Properties
    private let dataManager: DataManager
    private let locationManager: CLLocationManager
    private var storageManager = StorageManager.shared
    private var locationEnabled = false
    private var parameters: QueryParametersViewModel?
    
    // MARK: Initializers
    init(dataManager: DataManager, locationManager: CLLocationManager) {
        self.dataManager = dataManager
        self.locationManager = locationManager
        super.init()
        
        locationManager.delegate = self
    }
    
    // MARK: Private Methods
    private func makeQuery(near location: CLLocationCoordinate2D, within radius: Int, in country: String? = nil, maxCount: Int) {
        dataManager.fetchPoints(near: location, within: radius, in: country, maxCount: maxCount) { [weak self] result in
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
            presenter?.pointsLoadingFailed(with: .locationPermissionNotGranted)
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
            presenter?.pointsLoadingFailed(with: .locationError)
            return
        }
        
        guard let parameters else { return }
        
        makeQuery(near: location.coordinate, within: parameters.radius, maxCount: 10_000)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presenter?.pointsLoadingFailed(with: .locationError)
    }
}
