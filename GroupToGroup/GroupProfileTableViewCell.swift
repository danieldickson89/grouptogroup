//
//  GroupProfileTableViewCell.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/6/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class GroupProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithMemberCell(user: User) {
        
        self.cellView.backgroundColor = UIColor.chatListBackgroundColor()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
        
        dispatch_async(dispatch_get_main_queue()) {
            if let userID = user.identifier {
                ImageController.imageForUser(userID, completion: { (success, image) in
                    if success {
                        self.profileImage.image = image
                    } else {
                        self.profileImage.image = UIImage(named: "defaultImage")
                    }
                })
            }
        }
        nameLabel.text = user.username
        nameLabel.textColor = UIColor.whiteColor()
    }

}
