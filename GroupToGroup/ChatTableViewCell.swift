//
//  ChatTableViewCell.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/28/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftUIImageView: UIImageView!
    @IBOutlet weak var leftUIView: UIView!
    @IBOutlet weak var leftUILabel: UILabel!

    @IBOutlet weak var rightUIImageView: UIImageView!
    @IBOutlet weak var rightUIView: UIView!
    @IBOutlet weak var rightUILabel: UILabel!
    
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
        
        rightUILabel.text = message.text
        rightUILabel.textColor = UIColor.whiteColor()
        rightUIView.backgroundColor = UIColor.myBlueColor()
        rightUIView.layer.cornerRadius = 6.0
        rightUIImageView.image = UIImage(named: "sample")
        
    }
    
    func updateWithGrayMessage(message: Message) {
     
        leftUILabel.text = message.text
        leftUILabel.textColor = UIColor.blackColor()
        leftUIView.backgroundColor = UIColor.myGrayColor()
        leftUIView.layer.cornerRadius = 6.0
        leftUIImageView.image = UIImage(named: "sample")
        
    }
}
