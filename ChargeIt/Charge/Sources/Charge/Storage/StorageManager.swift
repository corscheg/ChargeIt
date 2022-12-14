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
    func add() throws {
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
