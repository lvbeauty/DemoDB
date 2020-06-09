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
    
//    private let photoPickCtrl = UIImagePickerController()
//    private let vc = TableViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - Image Picker Controller Delegate

//extension TableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate
//{
//    func imgPkrSetUp()
//    {
//        photoPickCtrl.delegate = self
//        photoPickCtrl.allowsEditing = true
//        photoPickCtrl.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .savedPhotosAlbum
//        studentImageView.isUserInteractionEnabled = true
//        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(vc.photoPickButtonTapped(_:photoPickCtrl:)))
//        imageGesture.delegate = self
//        imageGesture.numberOfTouchesRequired = 1
//        imageGesture.numberOfTapsRequired = 1
//        studentImageView.addGestureRecognizer(imageGesture)
//    }

//    @objc func photoPickButtonTapped(_ sender: UIImageView) {
////        self.present(photoPickCtrl, animated: true, completion: nil)
//    }

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = info[.editedImage] as? UIImage else { return }
//        studentImageView.image = image
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}


//    let storedP = 10
//
//    let storedPr1 = 10 * 3
//
//    var storedPr = 10 * 3
//
//    let storedPro = {
//        return 10
//    }()
//
//    let storedPro0 = {
//        return 10
//    }
//
//    var variable1 = {
//        return 20 * 10
//    }
//
//    lazy var variable2 = {
//        return 10 * 10
//    }
    
//    lazy let storedPro1 = {
//        return 10
//    }()
//
//    lazy var storedPro3 = {
//        return 10
//    }()
//
//    let computedPro1: Int {
//       return 10
//    }
//
//    let computedPro2: Int {
//       return 10
//    }()
//
//    var computedPro3: Int {
//       return 10
//    }()
//
//    var computedPro: Int {
//       return 10
//    }

//print(storedPro3)
//   print(storedPro0())
//   print(storedP)
//   print(storedPr)
//   print(storedPr1)
//   print(computedPro)
