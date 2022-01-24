//
//  User+CoreDataProperties.swift
//  taskify-app
//
//  Created by Niraj Sutariya
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var contact: String?
    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var type: String?

}

extension User : Identifiable {

}
