//
//  FriendRequestTableViewCell.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confirmButton: PrimaryButton!
    @IBOutlet weak var declineButton: SecondaryButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(user: User) {
        nameLabel.text = user.name
    }
    
}
