//
//  ChatTableViewCell.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/28/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rightTopUIView: UIView!
    @IBOutlet weak var rightMainUIView: UIView!
    @IBOutlet weak var rightUIView: UIView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightNameStamp: UILabel!
    
    @IBOutlet weak var leftTopUIView: UIView!
    @IBOutlet weak var leftMainUIView: UIView!
    @IBOutlet weak var leftUIView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftNameStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ChatTableViewCell {
    
    func updateWithUsersMessage(message: Message) {
        rightMainUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightTopUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightLabel.text = message.text
        rightLabel.textColor = UIColor.myGreenColor()
        rightUIView.backgroundColor = UIColor.blackColor()
        rightUIView.layer.cornerRadius = 6.0
        rightNameStamp.textColor = .whiteColor()
        UserController.userForIdentifier(message.senderID) { (user) in
            self.rightNameStamp.text = user?.username
        }
    }
    
    func updateWithRightMemberMessage(message: Message) {
        rightMainUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightTopUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightLabel.text = message.text
        rightLabel.textColor = UIColor.myGreenColor()
        rightUIView.backgroundColor = UIColor(white: 0.75, alpha: 0.25)
        rightUIView.layer.cornerRadius = 6.0
        rightNameStamp.textColor = .whiteColor()
        UserController.userForIdentifier(message.senderID) { (user) in
            self.rightNameStamp.text = user?.username
        }
    }
    
    func updateWithLeftMemberMessage(message: Message) {
     
        leftMainUIView.backgroundColor = UIColor.menuBackgroundColor()
        leftTopUIView.backgroundColor = UIColor.menuBackgroundColor()
        leftLabel.text = message.text
        leftLabel.textColor = UIColor.blackColor()
        leftUIView.backgroundColor = UIColor.myGreenColor()
        leftUIView.layer.cornerRadius = 6.0
        leftNameStamp.textColor = UIColor.whiteColor()
        UserController.userForIdentifier(message.senderID) { (user) in
            self.leftNameStamp.text = user?.username
        }
    }
}
