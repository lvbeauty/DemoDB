//
//  ViewModel.swift
//  Student_Database
//
//  Created by Tong Yi on 6/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ViewModel
{
    var arrayOfMajor = [String]()
    private let coreDataManager = CoreDataManager.shared
    var updateHandler: () -> () = {}
    typealias Handler = () -> ()
    
    init() { setupCoreDataManager() }
    
    private func setupCoreDataManager()
    {
        coreDataManager.fetchObj()
        coreDataManager.loadStudent()
    }
    
    func numberOfRows(at section: Int) -> Int
    {
        let sections = coreDataManager.fetchedResultController.sections!
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func studentObject(at indexPath: IndexPath) -> Student
    {
        let student = coreDataManager.fetchedResultController.object(at: indexPath) as! Student
        return student
    }
    
    func fetchObj(majorArr: [String]? = nil, sortKey: String? = nil, selectedScopeIndx: Int? = nil, searchText: String? = nil)
    {
        coreDataManager.fetchObj(majorArr: majorArr, sortKey: sortKey, selectedScopeIndx: selectedScopeIndx, searchText: searchText)
    }
    
    //MARK: - CRUD
    
    func createStudent(id: Int64?, name: String, major: String, majorArr: [String]? = nil, sortKey: String? = nil, sender: UIViewController)
    {
        coreDataManager.createStudent(id: id, name: name, major: major, sender: sender)
        refreshData(majorArr: majorArr, sortKey: sortKey)
    }
    
    func loadStudentMajor(/*handler: ((Student) -> ())? = nil*/) -> [FilterMajor]
    {
        var majorArr = [String]()
        var majorData = [FilterMajor]()
        
        coreDataManager.loadStudent
        { (student) in
            guard let major = student.major else { return }
            
            majorArr.append(major)
        }
        
        majorArr.removeDuplicates()
        majorArr.sort( by: { $0 < $1 } )
        
        for major in majorArr
        {
            majorData.append(FilterMajor(majorData: major, isPicked: false))
        }
        
        return majorData
    }
    
    func updateStudent(id: Int64, nameText: String = "", majorText: String = "", majorArr: [String]? = nil, sortKey: String? = nil, photo: Data? = nil)
    {
        coreDataManager.updateStudent(id: id, nameText: nameText, majorText: majorText, photo: photo)
        refreshData(majorArr: majorArr, sortKey: sortKey)
    }
    
    func deleteStudent(id: Int64, completeState: Bool = true)
    {
        coreDataManager.deleteStudent(id: id, completeState: completeState)
    }
    
    func refreshData(majorArr: [String]? = nil, sortKey: String? = nil)
    {
        _ = sortKey == "Sort" ? coreDataManager.fetchObj(majorArr: majorArr) :
                                coreDataManager.fetchObj(majorArr: majorArr, sortKey: sortKey)
        updateHandler()
    }
}
