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
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightBubbleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTopUIView: UIView!
    @IBOutlet weak var leftMainUIView: UIView!
    @IBOutlet weak var leftUIView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftNameStamp: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftBubbleConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let leftImage = leftImageView {
            leftImage.image = UIImage(named: "defaultImage")

        } else if let rightImage = rightImageView {
            rightImage.image = UIImage(named: "defaultImage")

        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension ChatTableViewCell {
    
    func updateWithUsersMessage(message: Message) {
        
        rightImageView.image = UIImage(named: "blankPic")
        rightNameStamp.text = ""
        rightImageView.layer.cornerRadius = rightImageView.frame.size.width / 2
        rightImageView.layer.masksToBounds = true
        ImageController.imageForBase64String(message.senderImageString) { (success, image) in
            if success {
                self.rightImageView.image = image
            } else {
                self.rightImageView.image = UIImage(named: "defaultImage")
            }
        }
        rightMainUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightTopUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightLabel.text = message.text
        rightLabel.textColor = UIColor.myGreenColor()
        rightUIView.backgroundColor = UIColor.blackColor()
        rightUIView.layer.cornerRadius = 6.0
        rightNameStamp.textColor = .whiteColor()
        rightNameStamp.text = message.senderUsername
    }
    
    func updateWithRightMemberMessage(message: Message) {
        
//        switch message.text.characters.count {
//        case 1...5: rightBubbleConstraint.constant = 280
//        case 6...15: rightBubbleConstraint.constant = 240
//        case 16...25: rightBubbleConstraint.constant = 180
//        default: rightBubbleConstraint.constant = 120
//        }
        rightImageView.image = UIImage(named: "blankPic")
        rightNameStamp.text = ""
        rightImageView.layer.cornerRadius = rightImageView.frame.size.width / 2
        rightImageView.layer.masksToBounds = true
        ImageController.imageForBase64String(message.senderImageString) { (success, image) in
            if success {
                self.rightImageView.image = image
            } else {
                self.rightImageView.image = UIImage(named: "defaultImage")
            }
        }
        rightMainUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightTopUIView.backgroundColor = UIColor.menuBackgroundColor()
        rightLabel.text = message.text
        rightLabel.textColor = UIColor.myGreenColor()
        rightUIView.backgroundColor = UIColor(white: 0.75, alpha: 0.25)
        rightUIView.layer.cornerRadius = 6.0
        rightNameStamp.textColor = .whiteColor()
        rightNameStamp.text = message.senderUsername
    }
    
    func updateWithLeftMemberMessage(message: Message) {
     
//        switch message.text.characters.count {
//        case 1...5: leftBubbleConstraint.constant = 280
//        case 6...15: leftBubbleConstraint.constant = 240
//        case 16...25: leftBubbleConstraint.constant = 180
//        default: leftBubbleConstraint.constant = 120
//        }
        leftImageView.image = UIImage(named: "blankPic")
        leftNameStamp.text = ""
        leftImageView.layer.cornerRadius = leftImageView.frame.size.width / 2
        leftImageView.layer.masksToBounds = true
        ImageController.imageForBase64String(message.senderImageString) { (success, image) in
            if success {
                self.leftImageView.image = image
            } else {
                self.leftImageView.image = UIImage(named: "defaultImage")
            }
        }
        leftMainUIView.backgroundColor = UIColor.menuBackgroundColor()
        leftTopUIView.backgroundColor = UIColor.menuBackgroundColor()
        leftLabel.text = message.text
        leftLabel.textColor = UIColor.blackColor()
        leftUIView.backgroundColor = UIColor.myGreenColor()
        leftUIView.layer.cornerRadius = 6.0
        leftNameStamp.textColor = UIColor.whiteColor()
        leftNameStamp.text = message.senderUsername
    }
}
