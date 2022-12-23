//
//  StorageManagerProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

protocol StorageManagerProtocol {
    func add(point: ChargingPoint) throws
    
    func isFavorite(by id: UUID) throws -> Bool
    
    @discardableResult
    func delete(by id: UUID) throws -> Bool
    
    func allPoints() throws -> [PointObj]
}
