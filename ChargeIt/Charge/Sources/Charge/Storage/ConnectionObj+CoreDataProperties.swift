//
//  ConnectionObj+CoreDataProperties.swift
//  ChargeIt
//
//  Created by Александр Казак-Казакевич on 18.12.2022.
//
//

import Foundation
import CoreData


extension ConnectionObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConnectionObj> {
        return NSFetchRequest<ConnectionObj>(entityName: "ConnectionObj")
    }

    @NSManaged public var current: String?
    @NSManaged public var fastChargeCapable: Bool
    @NSManaged public var level: String?
    @NSManaged public var type: String
    @NSManaged public var point: PointObj?

}
