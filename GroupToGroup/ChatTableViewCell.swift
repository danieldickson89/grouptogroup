//
//  ChatTableViewCell.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/28/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rightUIView: UIView!
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var leftUIView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ChatTableViewCell {
    
    func updateWithBlueMessage(message: Message) {
        
        rightLabel.text = message.text
        rightLabel.textColor = UIColor.whiteColor()
        rightUIView.backgroundColor = UIColor.myBlueColor()
        rightUIView.layer.cornerRadius = 6.0
        //rightImageView.image = UIImage(named: "sample")
        
    }
    
    func updateWithRightGrayMessage(message: Message) {
        
        rightLabel.text = message.text
        rightLabel.textColor = UIColor.blackColor()
        rightUIView.backgroundColor = UIColor.myGrayColor()
        rightUIView.layer.cornerRadius = 6.0
        //rightImageView.image = UIImage(named: "sample")
    }
    
    func updateWithGrayMessage(message: Message) {
     
        leftLabel.text = message.text
        leftLabel.textColor = UIColor.blackColor()
        leftUIView.backgroundColor = UIColor.myGrayColor()
        leftUIView.layer.cornerRadius = 6.0
        //leftImageView.image = UIImage(named: "sample")
        
    }
}
