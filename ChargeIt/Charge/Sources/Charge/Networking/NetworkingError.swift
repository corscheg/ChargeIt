//
//  NetworkingError.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation

/// An error that occure during search of the charging points.
enum NetworkingError: Error {
    case invalidURL
    case badResponse
    case connectionError
    case codingError
}

// MARK: - Localized Error
extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid"
        case .badResponse:
            return "The server response was invalid"
        case .connectionError:
            return "The networking error occured"
        case .codingError:
            return "The data returned by the server was invalid"
        }
    }
}
