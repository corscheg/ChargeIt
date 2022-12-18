//
//  URLsObj+CoreDataProperties.swift
//  ChargeIt
//
//  Created by Александр Казак-Казакевич on 18.12.2022.
//
//

import Foundation
import CoreData


extension URLsObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<URLsObj> {
        return NSFetchRequest<URLsObj>(entityName: "URLsObj")
    }

    @NSManaged public var url: URL
    @NSManaged public var point: PointObj?

}
