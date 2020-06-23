//
//  MappingV2ToV3.swift
//  Student_Database
//
//  Created by Tong Yi on 6/17/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import CoreData

class MappingV2ToV3: NSEntityMigrationPolicy
{
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws
    {
        if sInstance.entity.name == "Student"
        {
            
        }
    }
}
