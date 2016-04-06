//
//  SettingsViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/6/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

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
//        if let currentUserID = UserController.currentUser.identifier {
//            updateWithImageIdentifier(currentUserID)
//        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.profileImageTapped))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func profileImageTapped() {
        
        let alert = UIAlertController(title: "Sweet!", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateWithImageIdentifier(identifier: String) {
        
        ImageController.imageForIdentifier(identifier) { (image) -> Void in
            self.profileImage.image = image
        }
    }
    
}
