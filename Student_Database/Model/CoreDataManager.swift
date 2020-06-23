//
//  CoreDataManager.swift
//  Student_Database
//
//  Created by Tong Yi on 6/8/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager
{
    static let shared = CoreDataManager()
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>!
    var moc: NSManagedObjectContext!
    var studentMos = [Student]()
    typealias Handler = () -> ()
    
    private init() { moc = persistentContainer.viewContext }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer =
    {

        let container = NSPersistentContainer(name: "Student_Database")
        
//        let dirPath  = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
//        let storeURL = dirPath.appendingPathComponent("Student_Database.sqlite")
        if let url = container.persistentStoreDescriptions.first?.url
        {
            /*add necessary support for migration*/
            let description = NSPersistentStoreDescription(url: url)
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [description]
            /*add necessary support for migration*/
        }
    
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext ()
    {
//        let context = persistentContainer.viewContext
        if moc.hasChanges {
            do
            {
                try moc.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: - CRUD
    
    func fetchObj(majorArr: [String]? = nil, sortKey: String? = nil, selectedScopeIndx: Int? = nil, searchText: String? = nil)
    {
//        let startTime = CFAbsoluteTimeGetCurrent()
//        let context = persistentContainer.newBackgroundContext()
        
        let studentSort = NSSortDescriptor(key: sortKey ?? "id", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.sortDescriptors = [studentSort]
        fetchRequest.returnsObjectsAsFaults = true
        
        if let majorA = majorArr
        {
            fetchRequest.predicate = NSPredicate(format: "major IN %@", majorA)
        }
        
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
//            print(CFAbsoluteTimeGetCurrent() - startTime)
        }
        catch
        {
            fatalError("Failed to initialize FetchResultController: \(error.localizedDescription)")
        }
        
        // return objects as fault
        
//        for object in fetchedResultController.fetchedObjects as! [Student]
//        {
//            print(object) // fault
//            print(object.id)  // fault fired
//            print(object)  // load info
//        }
    }
    
    func fetchStudentThroughStudentID(id: Int64, handler: (Student) -> Void)
    {
        let updateRequest = NSFetchRequest<Student>(entityName: "Student")
        updateRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        var students: [Student]!
        do
        {
            students = try moc.fetch(updateRequest)
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        guard let student = students.first else { return }
        handler(student)
    }
    
    func createStudent(id: Int64?, name: String, major: String, sender: UIViewController)
    {
        var sameId = false
        
        guard let id = id, !name.isEmpty, !major.isEmpty else
        {
            AlertManager.shared.alert("WARNING!!", "Create New Student Failed!\nAll the Field are Required!", sender: sender)
            return
        }
        
        fetchStudentThroughStudentID(id: id)
        { _ in
            sameId = true
            AlertManager.shared.alert("WARNING!!", "This Student ID Has Already Exist!", sender: sender)
        }

        if !sameId
        {
//            the context associated with are configured as NSPrivateQueueConcurrencyType
//            let privateQueueContext = persistentContainer.newBackgroundContext()
//            let privateMOC2 = persistentContainer.performBackgroundTask(<#T##block: (NSManagedObjectContext) -> Void##(NSManagedObjectContext) -> Void#>)
//            let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            let privateChildContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateChildContext.parent = moc
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            let studentMo = Student(context: moc)
            studentMo.id = Int64(id)
            studentMo.name = name
            studentMo.major = major
            
            var task1Id: NSManagedObjectID!
            var task2Id: NSManagedObjectID!
            var passportId: NSManagedObjectID!
            
            print("1: \(Thread.current)\n\n")
            
            privateChildContext.perform {
                
                let todoObjectOne = Task(context: privateChildContext)
                let todoObjectSecond = Task(context: privateChildContext)
                let studentPassport = Passport(context: privateChildContext)
                
                print("2: \(Thread.current)\n\n")
                // Create a first todo object
                todoObjectOne.name = "First Task"
                todoObjectOne.details = "First Task Description"
                todoObjectOne.id = 1
                print("3: \(Thread.current)\n\n")
                // Create a second todo object
                todoObjectSecond.name = "Second Task"
                todoObjectSecond.details = "Second Task Description"
                todoObjectSecond.id = 2
                
                // Create a student passport object
                studentPassport.expiryDate = Date()
                studentPassport.number = "Student Passport Number"
                
                task1Id = todoObjectOne.objectID
                task2Id = todoObjectSecond.objectID
                passportId = studentPassport.objectID
                
            }
            
            print("4: \(Thread.current)\n\n")
            
            privateChildContext.performAndWait {
                print("5: \(Thread.current)\n\n")
                do
                {
                    try privateChildContext.save()
                }
                catch
                {
                    print(error.localizedDescription)
                }
            }
            // Assign Tasks to student object
            studentMo.tasks = NSSet(array: [moc.object(with: task1Id),
                                            moc.object(with: task2Id)])
            print("6: \(Thread.current)\n\n")
            // Assign passport to student object
            studentMo.passport = moc.object(with: passportId) as? Passport
            
            saveContext()
            print(CFAbsoluteTimeGetCurrent() - startTime)
            AlertManager.shared.alert("CONGRATULATION!", "This Student Has Been Created Successfully!", sender: sender)
        }
    }
    
    func loadStudent(handler: ((Student) -> ())? = nil)
    {
        do
        {
            let request = NSFetchRequest<Student>(entityName: "Student")
            studentMos = try moc.fetch(request)
            
            for studentMo in studentMos
            {
                handler?(studentMo)
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func updateStudent(id: Int64, nameText: String = "", majorText: String = "", photo: Data? = nil)
    {
        fetchStudentThroughStudentID(id: id) { (student) in
            if !nameText.isEmpty, !majorText.isEmpty
            {
                student.major = majorText
                student.name = nameText
            }

            if photo != nil
            {
                student.photo = photo
            }
            
            saveContext()
        }
    }
    
    func deleteStudent(id: Int64, completeState: Bool = true)
    {
        fetchStudentThroughStudentID(id: id) { (student) in
            moc.delete(student)
            
            if completeState
            {
                saveContext()
            }
        }
    }
}

// Example from Medium

extension CoreDataManager
{
    func fetchTaskFromCoreData()
    {
        // create a fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do
        {
            // Execute the fetch request
            let tasks = try moc.fetch(fetchRequest)
            
            for data in tasks
            {
                print(data.value(forKey: "details") ?? "No Data Found")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addTodoTask()
    {
        //we create a entity object Task is our entity and we are creating in this managedObjectContext
        let todoEntity = NSEntityDescription.entity(forEntityName: "Task", in: moc)!
        // Adding records in todo list
        let todo = NSManagedObject(entity: todoEntity, insertInto: moc)
        
        todo.setValue("First Item", forKey: "name")
        todo.setValue("First Item Description", forKey: "details")
        todo.setValue(1, forKey: "id")
        
        saveContext()
    }
    
    func deleteTaskFromCoreData()
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do
        {
            // Execute the fetch request
            let tasks = try moc.fetch(fetchRequest)
            
            //Delete data
            for data in tasks
            {
                moc.delete(data)
            }
            // Commit to disk
            saveContext()
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchTaskFromCoreDataWithObjectOrientedWay()
    {
        // create a fetch request
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do
        {
            // Execute the fetch request
            let tasks = try moc.fetch(fetchRequest)
            
            for data in tasks
            {
                print(data.value(forKey: "details") ?? "No Data Found")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addTodoTaskWithObjectOrientedWay()
    {
        // Create a todo list object
        let todoObject = Task(context: moc)
        todoObject.name = "First Item"
        todoObject.details = "First Item Description"
        todoObject.id = 1
        
        saveContext()
    }
    
    func deleteTaskFromCoreDataWithObjectOrientedWay()
    {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do
        {
            // Execute the fetch request
            let tasks = try moc.fetch(fetchRequest)
            
            //Delete data
            for data in tasks
            {
                moc.delete(data)
            }
            // Commit to disk
            saveContext()
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchTaskFromCoreDataWithEntityHavingRelationshipWithOtherEntityObjectOrientedWay()
    {
        // create a fetch request
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do
        {
            // Execute the fetch request
            let tasks = try moc.fetch(fetchRequest)
            
            for task in tasks
            {
                //print task details
                print(task.details ?? "No Data Found")
                
                //print student info by using task object
                print(task.ofStudent ?? "No Student Name")
                
                // print student passport info by using task object
//                print(task.ofStudent?.passport?.number ?? "No student Passport")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addTodoTaskWithEntityHavingRelationshipWithOtherEntityObjectOrientedWay()
    {
        // Create a first todo object
        let todoObjectOne = Task(context: moc)
        todoObjectOne.name = "First Item"
        todoObjectOne.details = "First Item Description"
        todoObjectOne.id = 1
        
        // Create a second todo object
        let todoObjectSecond = Task(context: moc)
        todoObjectSecond.name = "Second Item"
        todoObjectSecond.details = "Second Item Description"
        todoObjectSecond.id = 2
        
        // Create a student passport object
        let studentPassport = Passport(context: moc)
        studentPassport.expiryDate = Date()
        studentPassport.number = "Student Passport Number"
        
        // Create a student object
        let student = Student(context: moc)
        student.id = 123
        student.name = "Student Name"
        student.major = "Student Major"
        
        // Assign Tasks to student object
        student.tasks = NSSet(array: [todoObjectOne, todoObjectSecond])
        
        // Assign passport to student object
        student.passport = studentPassport
        
        // Save to persistant store
        saveContext()
    }
    
    func deleteTaskFromCoreDataWithEntityHavingRelationshipWithOtherEntity()
    {
        // Create fetch Request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        
        do
        {
            // Execute the fetch request
            let students = try moc.fetch(fetchRequest)
            
            // Delete student object
            for student in students
            {
                moc.delete(student)
            }
            
            // fetch task
            let fetchResquestTask = NSFetchRequest<NSManagedObject>(entityName: "Task")
            let tasks = try moc.fetch(fetchResquestTask)
            print("task count \(String(describing: tasks.count))")
            
            // fetch passport
            let fetchResquestPassport = NSFetchRequest<NSManagedObject>(entityName: "Passport")
            let passports = try moc.fetch(fetchResquestPassport)
            print("passport count \(String(describing: passports.count))")
            
            saveContext()
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

