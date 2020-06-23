//
//  TableViewCell.swift
//  Student_Database
//
//  Created by Tong Yi on 6/6/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var studentImageView: UIImageView!
    
    private let coreDataManager = CoreDataManager.shared
    private let viewModel = ViewModel()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(indexPath: IndexPath)
    {
        let student = viewModel.studentObject(at: indexPath)
        
        self.idLabel.text = "ID:\t\t\t\t\(student.id)"
        self.nameLabel.text = "Name:\t\t\t\(student.name ?? "name")"
        self.majorLabel.text = "Major:\t\t\t\(student.major ?? "major")"
        if let photo = student.photo
        {
            self.studentImageView.image = UIImage(data: photo)
        }
        else
        {
            self.studentImageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        self.backgroundColor = UIColor(red: 250/255, green: 200/255, blue: 210/255, alpha: 1)
    }

}
