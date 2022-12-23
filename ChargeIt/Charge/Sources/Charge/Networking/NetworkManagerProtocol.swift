//
//  NetworkManagerProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchPoints(
        latitude: Double,
        longitude: Double,
        within radius: Int,
        in country: String?,
        maxCount: Int,
        usageTypes: [Int]?,
        completion: @escaping (Result<[ChargingPoint], NetworkingError>) -> Void
    )
    
    func checkIn(_ check: CheckIn, completion: @escaping (Result<CheckInResponse, NetworkingError>) -> Void)
}
