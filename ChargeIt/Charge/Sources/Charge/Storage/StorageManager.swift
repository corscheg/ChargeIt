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
    
    // MARK: Public Properties
    func add(point: DetailPointViewModel) {
        let pointObj = PointObj(context: container.viewContext)
        
        pointObj.id = point.id
        pointObj.approximateLocation = point.approximateLocation
        pointObj.locationTitle = point.locationTitle
        pointObj.addressFirst = point.addressFirst
        pointObj.addressSecond = point.addressSecond
        pointObj.longitude = point.longitude
        pointObj.latitude = point.latitude
        
        point.connections.forEach {
            let connectionObj = ConnectionObj(context: container.viewContext)
            connectionObj.type = $0.type
            connectionObj.level = $0.level
            connectionObj.fastChargeCapable = $0.fastChargeCapable ?? false
            connectionObj.current = $0.current
            
            pointObj.addToConnections(connectionObj)
        }
        
        point.imageURLs.forEach {
            let urlObj = URLsObj(context: container.viewContext)
            urlObj.url = $0
            
            pointObj.addToUrls(urlObj)
        }
        
        saveContext()
    }
    
    func isFavorite(by id: UUID) -> Bool {
        fetch(by: id) != nil
    }
    
    @discardableResult
    func delete(by id: UUID) -> Bool {
        guard let pointObj = fetch(by: id) else {
            return false
        }
        
        container.viewContext.delete(pointObj)
        saveContext()
        return true
    }
    
    // MARK: Private Methods
    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Saving error: \(error)")
            }
        }
    }
    
    private func fetch(by id: UUID) -> PointObj? {
        let request = PointObj.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        
        do {
            return try container.viewContext.fetch(request).first
        } catch {
            return nil
        }
    }
}
