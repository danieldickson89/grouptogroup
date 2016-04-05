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
    
    @IBOutlet weak var leftTopUIView: UIView!
    @IBOutlet weak var leftMainUIView: UIView!
    @IBOutlet weak var leftUIView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    
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
        
    }
    
    func updateWithRightMemberMessage(message: Message) {
        rightMainUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightTopUIView.backgroundColor = UIColor.menuBackgroundColor()
        
        rightLabel.text = message.text
        rightLabel.textColor = UIColor.blackColor()
        rightUIView.backgroundColor = UIColor.myGreenColor()
        rightUIView.layer.cornerRadius = 6.0
    }
    
    func updateWithLeftMemberMessage(message: Message) {
     
        leftMainUIView.backgroundColor = UIColor.menuBackgroundColor()
        leftTopUIView.backgroundColor = UIColor.menuBackgroundColor()
        leftLabel.text = message.text
        leftLabel.textColor = UIColor.blackColor()
        leftUIView.backgroundColor = UIColor.myGrayColor()
        leftUIView.layer.cornerRadius = 6.0
        
    }
}
