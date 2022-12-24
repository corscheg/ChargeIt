//
//  LocationError.swift
//  
//
//  Created by Александр Казак-Казакевич on 22.12.2022.
//

import Foundation

/// An error that may occure during location process.
enum LocationError: Error {
    case locationPermissionNotGranted
    case locationError
}

// MARK: - LocalizedError
extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationPermissionNotGranted:
            return "Grant location permission in Settings"
        case .locationError:
            return "Unable to request location"
        }
    }
}
