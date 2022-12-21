//
//  PointObj+CoreDataProperties.swift
//  ChargeIt
//
//  Created by Александр Казак-Казакевич on 18.12.2022.
//
//

import Foundation
import CoreData


extension PointObj {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PointObj> {
        return NSFetchRequest<PointObj>(entityName: "PointObj")
    }

    @NSManaged public var addressFirst: String?
    @NSManaged public var addressSecond: String?
    @NSManaged public var country: String
    @NSManaged public var latitude: Double
    @NSManaged public var locationTitle: String?
    @NSManaged public var longitude: Double
    @NSManaged public var state: String?
    @NSManaged public var town: String?
    @NSManaged public var uuid: UUID
    @NSManaged public var connections: NSSet
    @NSManaged public var urls: NSSet
    @NSManaged public var serverID: Int32

}

// MARK: Generated accessors for connections
extension PointObj {

    @objc(addConnectionsObject:)
    @NSManaged public func addToConnections(_ value: ConnectionObj)

    @objc(removeConnectionsObject:)
    @NSManaged public func removeFromConnections(_ value: ConnectionObj)

    @objc(addConnections:)
    @NSManaged public func addToConnections(_ values: NSSet)

    @objc(removeConnections:)
    @NSManaged public func removeFromConnections(_ values: NSSet)

}

// MARK: Generated accessors for urls
extension PointObj {

    @objc(addUrlsObject:)
    @NSManaged public func addToUrls(_ value: URLsObj)

    @objc(removeUrlsObject:)
    @NSManaged public func removeFromUrls(_ value: URLsObj)

    @objc(addUrls:)
    @NSManaged public func addToUrls(_ values: NSSet)

    @objc(removeUrls:)
    @NSManaged public func removeFromUrls(_ values: NSSet)

}
