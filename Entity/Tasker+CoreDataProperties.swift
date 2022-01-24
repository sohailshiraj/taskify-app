//
//  Tasker+CoreDataProperties.swift
//  taskify-app
//
//  Created by Niraj Sutariya
//
//

import Foundation
import CoreData


extension Tasker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasker> {
        return NSFetchRequest<Tasker>(entityName: "Tasker")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var contact: String?
    @NSManaged public var gender: Bool

}

extension Tasker : Identifiable {

}
