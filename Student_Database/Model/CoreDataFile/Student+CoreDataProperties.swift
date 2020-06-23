//
//  Student+CoreDataProperties.swift
//  Student_Database
//
//  Created by Tong Yi on 6/18/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var id: Int64
    @NSManaged public var major: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var passport: Passport?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Student {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
