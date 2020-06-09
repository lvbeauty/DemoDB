//
//  TableViewController.swift
//  Student_Database
//
//  Created by Tong Yi on 6/6/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController
{
    @IBOutlet weak var trushButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!

    private let searchController = UISearchController(searchResultsController: nil)
    private var idTF: UITextField!
    private var nameTF: UITextField!
    private var majorTF: UITextField!
    private let photoPickCtrl = UIImagePickerController()
    private var photoIndexPath: IndexPath!
    var dataSource = [Student]()
    
    //MARK: - view life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        CoreDataManager.appDelegate = UIApplication.shared.delegate as? AppDelegate
        setupNavBar()
        CoreDataManager.fetchObj()
        setup()
        CoreDataManager.loadStudent()
        setupPhotoPickrCtrl()
    }
    
    //MARK: - initialization
    
    private func setup()
    {
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = true
        trushButton.isEnabled = false
    }
    
    private func setupNavBar()
    {
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["name", "id", "major"]
        searchController.searchBar.placeholder = "Search Student"
        searchController.searchBar.selectedScopeButtonIndex = 0
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.leftBarButtonItem = self.editButtonItem
//        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        self.title = "Student Info"
    }
    
    func setupPhotoPickrCtrl()
    {
        photoPickCtrl.delegate = self
        photoPickCtrl.allowsEditing = true
        photoPickCtrl.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .savedPhotosAlbum
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return CoreDataManager.fetchedResultController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sections = CoreDataManager.fetchedResultController.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    //MARK: - Table view delegate

    private func configureCell(cell: TableViewCell, indexPath: IndexPath)
    {
        let student = CoreDataManager.fetchedResultController.object(at: indexPath) as! Student
        
        cell.idLabel.text = "ID:             \(student.id)"
        cell.nameLabel.text = "Name:       \(student.name ?? "name")"
        cell.majorLabel.text = "Major:       \(student.major ?? "major")"
        if let photo = student.photo
        {
            cell.studentImageView.image = UIImage(data: photo)
        }
        else
        {
            cell.studentImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! TableViewCell
        
        self.configureCell(cell: cell, indexPath: indexPath)
        cell.backgroundColor = UIColor(red: 250/255, green: 200/255, blue: 210/255, alpha: 1)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        photoIndexPath = indexPath
        
        guard !isEditing else { return }
        let student = CoreDataManager.fetchedResultController.object(at: indexPath) as! Student
        guard let name = student.name else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        action(name, String(student.id), action: "update") { _ in
            CoreDataManager.updateStudent(id: student.id, majorText: self.majorTF.text) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let student = CoreDataManager.fetchedResultController.object(at: indexPath) as! Student

        if editingStyle == .delete
        {
            CoreDataManager.deleteStudent(id: student.id)
            CoreDataManager.refreshStudent {
                self.tableView.reloadData()
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool)
    {
        super.setEditing(editing, animated: animated)
        
        if isEditing
        {
            addButton.isEnabled = false
            trushButton.isEnabled = true
        }
        else{
            addButton.isEnabled = true
            trushButton.isEnabled = false
        }
    }

    //MARK: - IBAction
    
    @IBAction func addButtonTapped(_ sender: Any)
    {
        action("Add Student", "Add Student Infomation Below", action: "add", handler: self.save(action:))
    }
    
    @IBAction func trushButtonTapped(_ sender: Any)
    {
        if let selectedRows = tableView.indexPathsForSelectedRows
        {
            for inPath in selectedRows
            {
                let student = CoreDataManager.fetchedResultController.object(at: inPath) as! Student
             
                CoreDataManager.deleteStudent(id: student.id)
            }
    
            CoreDataManager.refreshStudent {
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: - Search Result updating and Delegate

extension TableViewController: /*UISearchResultsUpdating,*/ UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if !searchText.isEmpty
        {
            CoreDataManager.fetchObj(selectedScopeIndx: searchBar.selectedScopeButtonIndex, searchText: searchText)
            tableView.reloadData()
        }
        else
        {
            CoreDataManager.fetchObj()
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        if let searchText = searchBar.searchTextField.text, !searchText.isEmpty
        {
            CoreDataManager.fetchObj(selectedScopeIndx: searchBar.selectedScopeButtonIndex, searchText: searchText)
            tableView.reloadData()
        }
        else
        {
            CoreDataManager.fetchObj()
            tableView.reloadData()
        }
    }
    
//    func updateSearchResults(for searchController: UISearchController) {}
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        CoreDataManager.fetchObj()
        tableView.reloadData()
    }
}

//MARK: - Text Field Delegate

extension TableViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Alert controller
extension TableViewController
{
    func action(_ title: String, _ message: String, action: String, handler: ((UIAlertAction) -> Void)?)
    {
        let actionController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionController.addAction(saveAction)
        actionController.addAction(cancelAction)
        
        if action == "add"
        {
            actionController.addTextField(configurationHandler: idTextField(_:))
            actionController.addTextField(configurationHandler: nameTextField(_:))
        }
        else
        {
            let imageAction = UIAlertAction(title: "Upload Photo", style: .default) { _ in
                self.present(self.photoPickCtrl, animated: true, completion: nil)
            }
            
            actionController.addAction(imageAction)
        }
        
        actionController.addTextField(configurationHandler: majorTextField(_:))
      
        self.present(actionController, animated: true, completion: nil)
    }
    
    func save(action: UIAlertAction)
    {
        guard let id = idTF.text, let name = nameTF.text, let major = majorTF.text else { return }
        CoreDataManager.createStudent(id: Int64(id)!, name: name, major: major) { (sameId) in
            if sameId
            {
                alert("WARNING!!", "This Student ID Has Already Exist!")
            }
            else
            {
                self.tableView.reloadData()
            }
        }
    }
    
    func idTextField(_ textField: UITextField)
    {
        idTF = textField
        idTF.placeholder = "ID"
        textField.keyboardType = .numberPad
    }
    
    func nameTextField(_ textField: UITextField)
    {
        nameTF = textField
        nameTF.placeholder = "Name"
        textField.keyboardType = .default
    }
    
    func majorTextField(_ textField: UITextField)
    {
        majorTF = textField
        majorTF.placeholder = "Major"
        textField.keyboardType = .default
    }
    
    func alert(_ title: String, _ message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            NSLog ("OK Pressed.")}

        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension TableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let student = CoreDataManager.fetchedResultController.object(at: photoIndexPath) as! Student
        let imageData = image.pngData()
        CoreDataManager.updateStudent(id: student.id, photo: imageData) {
            self.tableView.reloadData()
        }
//        imageCell.studentImageView.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



