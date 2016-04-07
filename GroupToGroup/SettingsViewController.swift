//
//  SettingsViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/6/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        usernameLabel.text = UserController.currentUser.username
        view.backgroundColor = UIColor.chatListBackgroundColor()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
        if let userID = UserController.currentUser.identifier {
            ImageController.imageForUser(userID, completion: { (image) in
                self.profileImage.image = image
            })
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.profileImageTapped))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func profileImageTapped() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let userID = UserController.currentUser.identifier, image = image {
            ImageController.uploadImage(userID, image: image) { (identifier) in
                self.profileImage.image = image
            }
        }
    }
    
//    func updateWithImageIdentifier() {
//        if let userID = UserController.currentUser.identifier {
//            ImageController.imageForUser(userID, completion: { (image) in
//                self.profileImage.image = image
//            })
//        }
//    }
}
