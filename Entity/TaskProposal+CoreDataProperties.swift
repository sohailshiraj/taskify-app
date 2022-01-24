//
//  TaskProposal+CoreDataProperties.swift
//  taskify-app
//
//  Created by Ali Ahad
//
//

import Foundation
import CoreData


extension TaskProposal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskProposal> {
        return NSFetchRequest<TaskProposal>(entityName: "TaskProposal")
    }

    @NSManaged public var status: String?
    @NSManaged public var submissionDate: Date?
    @NSManaged public var details: String?
    @NSManaged public var task: Task?
    @NSManaged public var tasker: User?

}

extension TaskProposal : Identifiable {

}
