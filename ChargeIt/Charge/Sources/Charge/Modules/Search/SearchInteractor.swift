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
    private let dataManager = DataManager.shared
    private let locationManager: CLLocationManager
    private let storageManager = StorageManager.shared
    private var locationEnabled = false
    private var parameters: QueryParametersViewModel?
    
    // MARK: Initializers
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
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
    
    func store(point: ChargingPoint) -> Bool {
        do {
            try storageManager.add(point: point)
            return true
        } catch {
            return false
        }
    }
    
    func delete(by id: UUID) -> Bool {
        do {
            try storageManager.delete(by: id)
            return true
        } catch {
            return false
        }
    }
    
    func isFavorite(by id: UUID) -> Bool {
        storageManager.isFavorite(by: id)
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
        
        dataManager.fetchPoints(near: location.coordinate, within: parameters.radius, maxCount: parameters.maxCount) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.pointsLoadingFailed(with: error)
            case .success(let points):
                self?.presenter?.pointsLoadingSucceeded(with: points)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presenter?.pointsLoadingFailed(with: .locationError)
    }
}
