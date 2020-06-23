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
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var viewModel = ViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var idTF: UITextField!
    private var nameTF: UITextField!
    private var majorTF: UITextField!
    private let photoPickCtrl = UIImagePickerController()
    private var photoIndexPath: IndexPath!
    private var studentName: String!
    private var StudentMajor: String!
    private let transition = SlidesInTransition()
    private var isSearchActive = false
    private var noResultLabel: UILabel!
    private var pView: UIPickerView! = UIPickerView()
    private let sortData = ["", "name", "id", "major"]
    private var totalMajor = [FilterMajor]()
    private var majorArray: [String]!
    private var sortTF: UITextField!
    private var sortText: String!
    private let refreshC = UIRefreshControl()
    private var headerView: UIView!
    
    //MARK: - view life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
        setupPhotoPickrCtrl()
        setupViewModel()
        setupTableView()
        pViewSetup()
        setupData()
    }
    
    //MARK: - initialization
    
    private func setupUI()
    {
        trashButton.isEnabled = false
        
        noResultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: self.tableView.bounds.height))
        noResultLabel.numberOfLines = 0
        noResultLabel.text = ""
        
        let sortFrame = CGRect(x: tableView.bounds.width/2 + 1, y: 0, width: tableView.bounds.width/2, height: 38)
        sortTF = UITextField(frame: sortFrame)
        sortTF.backgroundColor = UIColor(red: 250.0/255.0, green: 210.0/255.0, blue: 196.0/255.0, alpha: 1)
        sortTF.text = "Sort"
        sortTF.inputView = pView
        sortTF.textAlignment = .center
        sortTF.tintColor = .clear
    }
    
    private func setupViewModel()
    {
        viewModel.updateHandler = self.tableView.reloadData
    }
    
    private func setupTableView()
    {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 40))
        let filterFrame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width/2 - 1, height: 38)
        let filterButton = self.createButton(frame: filterFrame, title: "Filters", action: #selector(self.filterButtonClicked(_:)))
        
        headerView.addSubview(filterButton)
        headerView.addSubview(self.sortTF)
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.refreshControl = refreshC
        
        guard let ref = tableView.refreshControl else { return }
        ref.addTarget(self, action: #selector(self.handleRefesh(_:)), for: .valueChanged)
        ref.tintColor = .white
    }
    
    private func setupNavBar()
    {
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["name", "id", "major"]
        searchController.searchBar.placeholder = "Search Student"
        searchController.searchBar.selectedScopeButtonIndex = 0
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.delegate = self
        searchController.searchBar.showsScopeBar = false
        searchController.hidesNavigationBarDuringPresentation = true
//        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.leftBarButtonItem = self.editButtonItem
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        self.title = "Student Info"
    }
    
    private func setupPhotoPickrCtrl()
    {
        photoPickCtrl.delegate = self
        photoPickCtrl.allowsEditing = true
        photoPickCtrl.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .savedPhotosAlbum
    }
    
    private func setupData()
    {
        totalMajor = viewModel.loadStudentMajor()
        majorArray = [String]()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let numOfRows = viewModel.numberOfRows(at: section)
        
        if numOfRows == 0
        {
            tableView.backgroundView = isSearchActive ? showNoResultLabel(AppConstants.noSearchResult) :
                                                        showNoResultLabel(AppConstants.noDataToShow)
        }
        else
        {
            tableView.backgroundView = UIView()
        }

        return numOfRows
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! TableViewCell
        cell.configureCell(indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard !isEditing else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        photoIndexPath = indexPath
    
        let student = viewModel.studentObject(at: indexPath)
        
        guard let name = student.name else { return }
        
        studentName = student.name
        StudentMajor = student.major
        
        alertAction(name, String(student.id), action: "update") { _ in
            guard let nameT = self.nameTF.text, let majorT = self.majorTF.text else { return }
            self.viewModel.updateStudent(id: student.id, nameText: nameT, majorText: majorT, sortKey: self.sortText)
        }
        
        self.refreshFilterVC()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let student = viewModel.studentObject(at: indexPath)

        if editingStyle == .delete
        {
            viewModel.deleteStudent(id: student.id)
            viewModel.refreshData(sortKey: sortTF.text)
            self.refreshFilterVC()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool)
    {
        super.setEditing(editing, animated: animated)
        
        if isEditing
        {
            addButton.isEnabled = false
            trashButton.isEnabled = true
        }
        else{
            addButton.isEnabled = true
            trashButton.isEnabled = false
        }
    }

    //MARK: - IBAction
    
    @IBAction func addButtonTapped(_ sender: Any)
    {
        alertAction("Add Student", "Add Student Infomation Below", action: "add", handler: self.save(_:))
    }
    
    @IBAction func trushButtonTapped(_ sender: Any)
    {
        if let selectedRows = tableView.indexPathsForSelectedRows
        {
            var deleteFinishFlag = false
            for inPath in selectedRows
            {
                let student = viewModel.studentObject(at: inPath)
                
                if inPath.row == selectedRows.count - 1
                {
                    deleteFinishFlag = true
                }
                
                viewModel.deleteStudent(id: student.id, completeState: deleteFinishFlag)
            }
    
            viewModel.refreshData(sortKey: sortTF.text)
        }
        self.refreshFilterVC()
    }
    
    //MARK: - selected action & self made function
    
    @objc func filterButtonClicked(_ sender: UIButton)
    {
        guard let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else { return }
        filterVC.modalPresentationStyle = .overCurrentContext
        filterVC.transitioningDelegate = self
        filterVC.majorModel = self.totalMajor
        filterVC.delegate = self
        present(filterVC, animated: true, completion: nil)
    }
    
    @objc func handleRefesh(_ refreshControl: UIRefreshControl)
    {
        viewModel.fetchObj(/*majorArr: majorArray,*/ sortKey: sortText)
        tableView.reloadData()
        refreshFilterVC()
        tableView.refreshControl!.endRefreshing()
    }
    
    func createButton(frame: CGRect, title: String, action: Selector) -> UIButton
    {
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor(red: 250.0/255.0, green: 210.0/255.0, blue: 196.0/255.0, alpha: 1)
        button.setTitleColor(.darkText, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: UIControl.Event.touchUpInside)
        
        return button
    }
    
    func showNoResultLabel(_ text: String) -> UIView
    {
        noResultLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60)
        noResultLabel.text = text
        noResultLabel.textAlignment = NSTextAlignment.center
        noResultLabel.textColor = .white
        
        return noResultLabel
    }
    
    func refreshFilterVC()
    {
        self.totalMajor.removeAll()
        self.totalMajor = viewModel.loadStudentMajor()
    }
    
}

//MARK: - Search Result updating and Delegate

extension TableViewController: /*UISearchResultsUpdating,*/ UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if !searchText.isEmpty
        {
            viewModel.fetchObj(selectedScopeIndx: searchBar.selectedScopeButtonIndex, searchText: searchText)
            tableView.reloadData()
        }
        else
        {
            viewModel.fetchObj(sortKey: searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex])
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        if let searchText = searchBar.searchTextField.text, !searchText.isEmpty
        {
            viewModel.fetchObj(sortKey: sortText, selectedScopeIndx: searchBar.selectedScopeButtonIndex, searchText: searchText)
            
            tableView.reloadData()
        }
        else
        {
            viewModel.fetchObj(sortKey: sortText)
            tableView.reloadData()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.showsScopeBar = true
        isSearchActive = true
        tableView.tableHeaderView = nil
        tableView.reloadData()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.showsScopeBar = false
        isSearchActive = false
        tableView.tableHeaderView = headerView
        tableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        viewModel.fetchObj(sortKey: sortText)
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
    func alertAction(_ title: String, _ message: String, action: String, handler: ((UIAlertAction) -> Void)?)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: handler) //I use UIAlertAction
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField(configurationHandler: nameTextField(_:))
        alertController.addTextField(configurationHandler: majorTextField(_:))
        
        if action == "update"
        {
            let imageAction = UIAlertAction(title: "Upload Photo", style: .default)
            { _ in
                ActionManager.shared.action(imagePickerController: self.photoPickCtrl, sender: self)
            }
            
            alertController.addAction(imageAction)
            
            nameTF.text = studentName
            majorTF.text = StudentMajor
        }
        else
        {
            alertController.addTextField(configurationHandler: idTextField(_:))
            
            nameTF.text = ""
            majorTF.text = ""
        }
      
        self.present(alertController, animated: true, completion: nil)
    }
    
    func save(_: UIAlertAction)
    {
        guard let id = idTF.text, let name = nameTF.text, let major = majorTF.text else { return }

        viewModel.createStudent(id: Int64(id), name: name, major: major, sortKey: sortText, sender: self)
        
        refreshFilterVC()
    }
    
    func idTextField(_ textField: UITextField)
    {
        idTF = textField
        idTF.placeholder = "Enter ID"
        textField.keyboardType = .numberPad
    }
    
    func nameTextField(_ textField: UITextField)
    {
        nameTF = textField
        nameTF.placeholder = "Enter Name"
        nameTF.autocapitalizationType = .words
        textField.keyboardType = .default
    }
    
    func majorTextField(_ textField: UITextField)
    {
        majorTF = textField
        majorTF.placeholder = "Enter Major"
        majorTF.autocapitalizationType = .words
        textField.keyboardType = .default
    }
}

//MARK: - imagePicker Controller

extension TableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let student = viewModel.studentObject(at: photoIndexPath)
        let imageData = image.pngData()
        
        viewModel.updateStudent(id: student.id, sortKey: sortText, photo: imageData)
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Sliding Transition

extension TableViewController: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        transition.isPresenting = false
        return transition
    }
}

// MARK: - Protocol Function

extension TableViewController: DataTransferDelegate
{
    func addFilter(totalMajor: [FilterMajor])
    {
        self.totalMajor = totalMajor
        
        for major in totalMajor
        {
            if major.isPicked
            {
                majorArray.append(major.majorData)
            }
        }
        
        if majorArray.count > 0
        {
            viewModel.fetchObj(majorArr: majorArray, sortKey: sortText)
        }
        else
        {
            viewModel.fetchObj(sortKey: sortText)
        }
        
        tableView.reloadData()
        majorArray.removeAll()
    }
}

// MARK: - Picker View Function

extension TableViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func pViewSetup()
    {
        pView.dataSource = self
        pView.delegate = self
        dismissPV()
    }
    
    // MARK: - Picker View Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sortData.count
    }
    
    // MARK: - Picker View Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return sortData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if !sortData[row].isEmpty
        {
            self.sortTF.text = sortData[row]
            self.sortText = sortData[row]
            viewModel.fetchObj(sortKey: sortData[row])
            tableView.reloadData()
        }
        else
        {
            self.sortTF.text = "Sort"
            sortText = nil
            viewModel.fetchObj()
        }
        
        tableView.reloadData()
    }
    
    func dismissPV()
    {
        // difine tool Bar of the accessory view
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(sortAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        sortTF.inputAccessoryView = toolBar
    }
    
    @objc func sortAction()
    {
        sortTF.endEditing(true)
    }
}



