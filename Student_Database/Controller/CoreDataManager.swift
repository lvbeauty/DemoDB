//
//  CoreDataManager.swift
//  Student_Database
//
//  Created by Tong Yi on 6/8/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager
{
    static var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>!
    static var appDelegate: AppDelegate!
    static var moc: NSManagedObjectContext!
    static var studentMos = [Student]()
    
    class func fetchObj(selectedScopeIndx: Int? = nil, searchText: String? = nil)
    {
        let studentSort = NSSortDescriptor(key: "id", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        
        moc = self.appDelegate.persistentContainer.viewContext
        fetchRequest.sortDescriptors = [studentSort]
        if let index = selectedScopeIndx, let searchText = searchText
        {
            var filterKeyword = ""
            switch index {
            case 0:
                filterKeyword = "name"
            case 1:
                filterKeyword = "id"
            default:
                filterKeyword = "major"
            }

            fetchRequest.predicate = NSPredicate(format: "\(filterKeyword) contains[c] '\(searchText)'")
        }
        
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try self.fetchedResultController.performFetch()
        }
        catch
        {
            fatalError("Failed to initialize FetchResultController: \(error.localizedDescription)")
        }
    }
    
    class func fetchIDCheck(id: Int64, handler: (Student) -> Void)
    {
        let updateRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        updateRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        var students: [Student]!
        do
        {
            students = try moc.fetch(updateRequest) as? [Student]
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        for student in students
        {
            handler(student)
        }
    }
    
    class func createStudent(id: Int64, name: String, major: String, handler: (Bool) -> Void)
    {
        var sameId = false
        
        fetchIDCheck(id: id)
        { (student) in
            sameId = true
            handler(sameId)
        }

        if !sameId
        {
            let studentMo = NSEntityDescription.insertNewObject(forEntityName: "Student", into: moc) as! Student
            
            studentMo.id = Int64(id)
            studentMo.name = name
            studentMo.major = major
            refreshStudent {
                handler(sameId)
            }
        }
    }
    
    class func loadStudent()
    {
        do
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
            studentMos = try moc.fetch(request) as! [Student]
            
            for studentMo in studentMos
            {
                print(studentMo.id, studentMo.major!, studentMo.name!)
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    class func updateStudent(id: Int64, majorText: String? = nil, photo: Data? = nil, handler: () -> Void)
    {
        fetchIDCheck(id: id) { (student) in
            if majorText != nil
            {
                student.major = majorText
            }

            if photo != nil
            {
                student.photo = photo
            }
            
            refreshStudent {
                handler()
            }
        }
    }
    
    class func deleteStudent(id: Int64)
    {
        fetchIDCheck(id: id) { (student) in
            moc.delete(student)
        }
    }
    
    class func refreshStudent(handler: () -> Void)
    {
        appDelegate.saveContext()
        fetchObj()
        handler()
    }
    
    
}

