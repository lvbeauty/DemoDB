//
//  Task+CoreDataProperties.swift
//  Student_Database
//
//  Created by Tong Yi on 6/18/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var details: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var ofStudent: Student?

}
