//
//  Requester+CoreDataProperties.swift
//  taskify-app
//
//  Created by Jignesh Kumavat
//
//

import Foundation
import CoreData


extension Requester {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Requester> {
        return NSFetchRequest<Requester>(entityName: "Requester")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var contact: String?
    @NSManaged public var gender: String?

}

extension Requester : Identifiable {

}
