//
//  SearchBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import CoreLocation
import UIKit

/// Use this struct to build the Search module.
struct SearchBuilder {
    
    // MARK: Static Methods
    /// Build the module.
    static func build() -> SearchViewController {
        let networkManager = NetworkManager.shared
        let storageManager = StorageManager.shared
        let locationManager = CLLocationManager()
        let geocoder = CLGeocoder()
        let hapticsGenerator = UINotificationFeedbackGenerator()
        
        let interactor = SearchInteractor(networkManager: networkManager, storageManager: storageManager, locationManager: locationManager, geocoder: geocoder)
        let router = SearchRouter()
        let presenter = SearchPresenter(router: router, interactor: interactor)
        let view = SearchViewController(presenter: presenter, hapticsGenerator: hapticsGenerator)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
