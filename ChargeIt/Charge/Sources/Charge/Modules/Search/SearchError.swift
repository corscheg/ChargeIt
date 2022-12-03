//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation

enum SearchError: Error {
    case invalidURL
    case badResponse
    case networkingError
    case decodingError
    case locationPermissionNotGranted
    case locationError
}
