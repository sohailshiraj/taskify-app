//
//  TaskFeedback+CoreDataProperties.swift
//  taskify-app
//
//  Created by Ali Ahad
//
//

import Foundation
import CoreData


extension TaskFeedback {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskFeedback> {
        return NSFetchRequest<TaskFeedback>(entityName: "TaskFeedback")
    }

    @NSManaged public var rating: Int16
    @NSManaged public var review: String?
    @NSManaged public var date: Date?
    @NSManaged public var task: Task?

}

extension TaskFeedback : Identifiable {

}
