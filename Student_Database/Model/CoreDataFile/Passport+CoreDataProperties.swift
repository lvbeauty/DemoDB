//
//  Passport+CoreDataProperties.swift
//  Student_Database
//
//  Created by Tong Yi on 6/18/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//
//

import Foundation
import CoreData


extension Passport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Passport> {
        return NSFetchRequest<Passport>(entityName: "Passport")
    }

    @NSManaged public var expiryDate: Date?
    @NSManaged public var number: String?
    @NSManaged public var ofStudent: Student?

}
