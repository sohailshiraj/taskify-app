//
//  Task+CoreDataProperties.swift
//  taskify-app
//
//  Created by Sohail Shiraj.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var detail: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var hours: Int16
    @NSManaged public var ratePerHour: Int16
    @NSManaged public var startDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var feeback: TaskFeedback?
    @NSManaged public var location: Location?
    @NSManaged public var proposals: NSSet?
    @NSManaged public var requester: User?
    @NSManaged public var tasker: User?

}

// MARK: Generated accessors for proposals
extension Task {

    @objc(addProposalsObject:)
    @NSManaged public func addToProposals(_ value: TaskProposal)

    @objc(removeProposalsObject:)
    @NSManaged public func removeFromProposals(_ value: TaskProposal)

    @objc(addProposals:)
    @NSManaged public func addToProposals(_ values: NSSet)

    @objc(removeProposals:)
    @NSManaged public func removeFromProposals(_ values: NSSet)

}

extension Task : Identifiable {

}
