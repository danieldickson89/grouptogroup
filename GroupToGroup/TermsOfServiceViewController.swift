//
//  TermsOfServiceViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/7/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        doneButton.tintColor = .blueColor()
        doneButton.layer.borderColor = UIColor.blueColor().CGColor
        doneButton.layer.borderWidth = 1.5
        doneButton.layer.cornerRadius = 6.0
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
