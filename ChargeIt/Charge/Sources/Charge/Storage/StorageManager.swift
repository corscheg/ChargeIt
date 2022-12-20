//
//  StorageManager.swift
//  
//
//  Created by Александр Казак-Казакевич on 11.12.2022.
//

import Foundation
import CoreData

/// A class for saving points in Core Data.
final class StorageManager {
    
    // MARK: Static Properties
    static let shared = StorageManager()
    
    // MARK: Private Properties
    private var container: NSPersistentContainer
    
    // MARK: Initializers
    private init?() {
        let bundle = Bundle.module
        
        guard let url = bundle.url(forResource: "ChargingPoint", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: url) else {
            return nil
        }
        
        
        container = NSPersistentContainer(name: "ChargingPoint", managedObjectModel: model)
        
        container.loadPersistentStores { [weak self] _,_ in
            self?.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    // MARK: Public Methods
    func add(point: ChargingPoint) throws {
        let pointObj = PointObj(context: container.viewContext)
        
        pointObj.uuid = point.id
        pointObj.addressFirst = point.location.addressFirst
        pointObj.addressSecond = point.location.addressSecond
        pointObj.town = point.location.town
        pointObj.state = point.location.state
        pointObj.country = point.location.country.code
        pointObj.latitude = point.location.coordinates.latitude
        pointObj.longitude = point.location.coordinates.longitude
        pointObj.locationTitle = point.location.title
        
        Set(point.connections).forEach {
            let connectionObj = ConnectionObj(context: container.viewContext)
            connectionObj.type = $0.type.title
            connectionObj.level = $0.level?.title
            connectionObj.fastChargeCapable = $0.level?.fastChargeCapable ?? false
            
            switch $0.currentType?.id {
            case 10, 20:
                connectionObj.current = "AC"
            case 30:
                connectionObj.current = "DC"
            default:
                connectionObj.current = "Unknown"
            }

            pointObj.addToConnections(connectionObj)
        }
        
        point.mediaItems?.forEach {
            let urlObj = URLsObj(context: container.viewContext)
            urlObj.url = $0.url

            pointObj.addToUrls(urlObj)
        }
        
        try saveContext()
    }
    
    func isFavorite(by id: UUID) throws -> Bool {
        try fetch(by: id) != nil
    }
    
    @discardableResult
    func delete(by id: UUID) throws -> Bool {
        guard let pointObj = try fetch(by: id) else {
            return false
        }
        container.viewContext.delete(pointObj)
        
        try saveContext()
        
        return true
    }
    
    func allPoints() throws -> [PointObj] {
        let request = PointObj.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "uuid", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try container.viewContext.fetch(request)
            return result
        } catch {
            throw StorageError.internalError
        }
    }
    
    // MARK: Private Methods
    private func saveContext() throws {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                throw StorageError.savingFailed
            }
        }
    }
    
    private func fetch(by id: UUID) throws -> PointObj? {
        let request = PointObj.createFetchRequest()
        let predicate = NSPredicate(format: "uuid == %@", id as CVarArg)
        request.predicate = predicate
        
        do {
            let result = try container.viewContext.fetch(request).first
            return result
        } catch {
            throw StorageError.internalError
        }
    }
}
