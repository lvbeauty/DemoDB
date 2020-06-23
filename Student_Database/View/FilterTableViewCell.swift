//
//  FilterTableViewCell.swift
//  Student_Database
//
//  Created by Tong Yi on 6/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    var isPicked = false
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(major: FilterMajor?)
    {
        guard let major = major else { return }
        self.isPicked = major.isPicked
        self.checkImageView.image = isPicked ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        self.majorLabel.text = major.majorData
    }

}
