//
//  FilterTableViewController.swift
//  Student_Database
//
//  Created by Tong Yi on 6/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = ViewModel()
    private var hasPickedMajor = false
    private var index = 0
    var majorModel = [FilterMajor]()
    var delegate: DataTransferDelegate!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI()
    {
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return majorModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterTableViewCell
        
        cell.configureCell(major: majorModel[indexPath.row])
    
        return cell
    }
    
    // MARK: - Table view data Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        
        majorModel[indexPath.row].isPicked = !majorModel[indexPath.row].isPicked
        
        cell.configureCell(major: majorModel[indexPath.row])
    }

    @IBAction func closeButtonTapped(_ sender: Any)
    {
        delegate.addFilter(totalMajor: majorModel)
        dismiss(animated: true, completion: nil)
    }
}


