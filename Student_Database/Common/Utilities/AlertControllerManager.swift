//
//  AlertManager.swift
//  Student_Database
//
//  Created by Tong Yi on 6/17/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class AlertManager
{
    static let shared = AlertManager()
    
    private init() {}
    
    func alert(_ title: String, _ message: String, sender: UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            NSLog ("OK Pressed.")}

        alertController.addAction(okAction)
        
        sender.present(alertController, animated: true, completion: nil)
    }
}

class ActionManager
{
    static let shared = ActionManager()
    
    private init() {}
    
    func action(imagePickerController: UIImagePickerController, sender: UIViewController)
    {
        let alertController = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) -> Void in
            imagePickerController.sourceType = .camera
            sender.present(imagePickerController, animated: true, completion: nil)
        }
        
        let albumAction = UIAlertAction(title: "Photo Library", style: .default) { (action) -> Void in
            imagePickerController.sourceType = .photoLibrary
            sender.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        sender.present(alertController, animated: true, completion: nil)
    }
}
