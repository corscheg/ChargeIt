//
//  SearchError.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation

/// An error that occure during search of the charging points.
enum SearchError: Error {
    case invalidURL
    case badResponse
    case networkingError
    case decodingError
    case locationPermissionNotGranted
    case locationError
}

// MARK: - Localized Error
extension SearchError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid"
        case .badResponse:
            return "The server response was invalid"
        case .networkingError:
            return "The networking error occured"
        case .decodingError:
            return "The data returned by the server was invalid"
        case .locationPermissionNotGranted:
            return "Grant the permission for using your location"
        case .locationError:
            return "Your location can not be identified"
        }
    }
}
