//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import CoreLocation

class SearchInteractor: NSObject {
    
    // MARK: Public Properties
    weak var presenter: SearchPresenterProtocol?
    
    // MARK: Private Properties
    private let dataManager = DataManager()
    private let locationManager: CLLocationManager
    private var locationEnabled = false
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
    }
    
}

// MARK: - SearchInteractorProtocol
extension SearchInteractor: SearchInteractorProtocol {
    
    func loadNearbyPoints() {
        guard locationEnabled else {
            presenter?.pointsLoadingFailed(with: .locationPermissionNotGranted)
            return
        }
        
        locationManager.requestLocation()
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
        
        dataManager.fetchPoints(near: location.coordinate) { [weak self] result in
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
