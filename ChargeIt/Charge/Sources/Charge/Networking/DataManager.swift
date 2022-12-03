//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation
import CoreLocation

struct DataManager {
    
    // MARK: Private Properties
    private let session: URLSession
    private let baseURL: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openchargemap.io"
        components.path = "/v3"
        components.queryItems = [URLQueryItem(name: "key", value: "d1058095-baa1-426e-bfb9-2e0f8ba58f8c")]
        
        return components
    }()
    
    // MARK: Initializers
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: Public Methods
    func fetchPoints(near location: CLLocationCoordinate2D,
                     within radius: Double = 20,
                     completion: @escaping (Result<[ChargingPoint], Error>) -> Void) {
        var components = baseURL
        components.path.append("/poi")
        components.queryItems?.append(URLQueryItem(name: "latitude", value: location.latitude.description))
        components.queryItems?.append(URLQueryItem(name: "longitude", value: location.longitude.description))
        components.queryItems?.append(URLQueryItem(name: "distance", value: radius.description))
        
        guard let url = components.url else {
            
            #warning("Add error handling")
            print(components)
            return
        }
        
        print(url)
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data else {
                
                #warning("Add error handling")
                print(response)
                return
            }
            
            guard let points = try? JSONDecoder().decode([ChargingPoint].self, from: data) else {
                
                #warning("Add error handling")
                print(data)
                return
            }
            
            completion(.success(points))
        }
        
        task.resume()
    }
}
