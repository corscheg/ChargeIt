//
//  NetworkManager.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation

/// A manager used to fetch data from the OpenCharge API.
final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: Static Properties
    static let shared = NetworkManager()
    
    // MARK: Public Properties
    var session: URLSessionProtocol = URLSession.shared
    var baseURL: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openchargemap.io"
        components.path = "/v3"
        components.queryItems = [
            URLQueryItem(name: "key", value: "d1058095-baa1-426e-bfb9-2e0f8ba58f8c"),
            URLQueryItem(name: "distanceunit", value: "km"),
            URLQueryItem(name: "includecomments", value: "true")
        ]
        
        return components
    }()
    
    // MARK: Private Properties
    private let bearerToken = "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiI0MjU3NiIsIm5vbmNlIjoiODFlMGYxZmEtMjczOC00MDMxLTkyMmEtMDdiMjQ3N2ZiYjUxIiwibmJmIjoxNjcxNTg3NDcwLCJleHAiOjE2NzQyNjU4NzAsImlzcyI6Ik9wZW4gQ2hhcmdlIE1hcCIsImF1ZCI6ImFwaS5vcGVuY2hhcmdlbWFwLmlvIn0.pW7LS8oKZzhxWnoqYxRWwdg1Krru-yVT7aYZDTAAPuk"
    
    // MARK: Initializers
    private init() { }
    
    // MARK: Public Methods
    /// Fetch charging points with the given parameters.
    func fetchPoints(latitude: Double,
                     longitude: Double,
                     within radius: Int = 20,
                     in country: String? = nil,
                     maxCount: Int = 100,
                     usageTypes: [Int]? = nil,
                     completion: @escaping (Result<[ChargingPoint], NetworkingError>) -> Void) {
        var components = baseURL
        components.path.append("/poi")
        components.queryItems?.append(URLQueryItem(name: "latitude", value: latitude.description))
        components.queryItems?.append(URLQueryItem(name: "longitude", value: longitude.description))
        components.queryItems?.append(URLQueryItem(name: "distance", value: radius.description))
        components.queryItems?.append(URLQueryItem(name: "maxresults", value: maxCount.description))
        
        if let country {
            components.queryItems?.append(URLQueryItem(name: "countrycode", value: country))
        }
        if let usageTypes {
            let usageString = usageTypes.map { String($0) }.joined(separator: ",")
            components.queryItems?.append(URLQueryItem(name: "usagetypeid", value: usageString))
        }
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = dataTask(with: request, completion: completion)
        
        task.resume()
    }
    
    func checkIn(_ check: CheckIn, completion: @escaping (Result<CheckInResponse, NetworkingError>) -> Void) {
        guard let data = try? JSONEncoder().encode(check) else {
            completion(.failure(.codingError))
            return
        }
        
        var components = baseURL
        components.path = "/comment"
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = data
        
        let task = dataTask(with: request, completion: completion)
        
        task.resume() 
    }
    
    // MARK: Private Methods
    private func dataTask<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask {
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.connectionError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.badResponse))
                return
            }
            
            guard let data, let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.codingError))
                return
            }
            
            completion(.success(decoded))
        }
    }
}
