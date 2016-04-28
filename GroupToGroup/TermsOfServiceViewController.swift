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
    @IBOutlet weak var tosTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        doneButton.tintColor = .myGreenColor()
        doneButton.layer.borderColor = UIColor.myGreenColor().CGColor
        doneButton.layer.borderWidth = 1.5
        doneButton.layer.cornerRadius = 6.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tosTextView.setContentOffset(CGPointMake(0, 0), animated: true)
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
