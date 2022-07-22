//
//  AddFriendTableViewCell.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import UIKit

class AddFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sendRequestButton: PrimaryButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(user: User) {
        self.userNameLabel.text = user.name
    }
    
}
