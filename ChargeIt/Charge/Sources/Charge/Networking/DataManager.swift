//
//  DataManager.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation
import CoreLocation

/// A manager used to fetch data from the OpenCharge API.
struct DataManager {
    
    // MARK: Private Properties
    private let session: URLSession
    private let baseURL: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openchargemap.io"
        components.path = "/v3"
        components.queryItems = [
            URLQueryItem(name: "key", value: "d1058095-baa1-426e-bfb9-2e0f8ba58f8c"),
            URLQueryItem(name: "distanceunit", value: "km")
        ]
        
        return components
    }()
    
    // MARK: Initializers
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: Public Methods
    /// Fetch charging points with the given parameters.
    func fetchPoints(near location: CLLocationCoordinate2D,
                     within radius: Int = 20,
                     in country: String? = nil,
                     maxCount: Int = 100,
                     completion: @escaping (Result<[ChargingPoint], SearchError>) -> Void) {
        var components = baseURL
        components.path.append("/poi")
        components.queryItems?.append(URLQueryItem(name: "latitude", value: location.latitude.description))
        components.queryItems?.append(URLQueryItem(name: "longitude", value: location.longitude.description))
        components.queryItems?.append(URLQueryItem(name: "distance", value: radius.description))
        components.queryItems?.append(URLQueryItem(name: "maxresults", value: maxCount.description))
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.networkingError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.badResponse))
                return
            }
            
            guard let data, let points = try? JSONDecoder().decode([ChargingPoint].self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(points))
        }
        
        task.resume()
    }
}
