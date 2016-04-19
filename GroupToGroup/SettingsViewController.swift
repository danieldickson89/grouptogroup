//
//  SettingsViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/6/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        view.backgroundColor = UIColor.chatListBackgroundColor()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
        
        if let currentUser = UserController.currentUser {
            ImageController.imageForBase64String(currentUser.imageString, completion: { (success, image) in
                if success {
                    self.profileImage.image = image
                } else {
                    self.profileImage.image = UIImage(named: "defaultImage")
                }
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
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let user = UserController.currentUser, image = image {
            ImageController.uploadImage(user, image: image) { (identifier) in
                self.profileImage.image = image
            }
        }
    }
    
    @IBAction func linkButtonTapped(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Some icons were provided by www.icons8.com", message: "Would you like to see their website?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "No Thanks", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (iconsLink) -> Void in
            let icons8 = NSURL(string: "https://icons8.com")
            UIApplication.sharedApplication().openURL(icons8!)
        
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
}
