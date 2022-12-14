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
    
    // MARK: Public Properties
    var container: NSPersistentContainer
    static var shared = StorageManager()
    
    // MARK: Initializers
    private init() {
        let bundle = Bundle.module
        
        guard let url = bundle.url(forResource: "ChargingPoint", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Model not found!!!")
        }
        
        
        container = NSPersistentContainer(name: "ChargingPoint", managedObjectModel: model)
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        container.loadPersistentStores { storeDescription, error in
            if let error {
                print("Loading error: \(error)")
                fatalError()
            }
            
        }
    }
    
    // MARK: Public Methods
    func add(point: ChargingPoint) throws {
        let pointObj = PointObj(context: container.viewContext)
        
        pointObj.id = point.id
        pointObj.addressFirst = point.location.addressFirst
        pointObj.addressSecond = point.location.addressSecond
        pointObj.town = point.location.town
        pointObj.state = point.location.state
        pointObj.country = point.location.country.code
        pointObj.latitude = point.location.coordinates.latitude
        pointObj.longitude = point.location.coordinates.longitude
        pointObj.locationTitle = point.location.title
        
        point.connections.forEach {
            let connectionObj = ConnectionObj(context: container.viewContext)
            connectionObj.type = $0.type.title
            connectionObj.level = $0.level?.title
            connectionObj.fastChargeCapable = $0.level?.fastChargeCapable ?? false
            connectionObj.current = $0.currentType?.title

            pointObj.addToConnections(connectionObj)
        }
        
        point.mediaItems?.forEach {
            let urlObj = URLsObj(context: container.viewContext)
            urlObj.url = $0.url

            pointObj.addToUrls(urlObj)
        }
        
        try saveContext()
    }
    
    func isFavorite(by id: UUID) -> Bool {
        fetch(by: id) != nil
    }
    
    func delete(by id: UUID) throws {
        guard let pointObj = fetch(by: id) else {
            return
        }
        container.viewContext.delete(pointObj)
        
        try saveContext()
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
    
    private func fetch(by id: UUID) -> PointObj? {
        let request = PointObj.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        
        do {
            let result = try container.viewContext.fetch(request).first
            return result
        } catch {
            return nil
        }
    }
}
