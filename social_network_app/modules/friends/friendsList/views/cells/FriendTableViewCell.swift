//
//  FriendTableViewCell.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendUserNameLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var deleteFriendButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(user: User) {
        friendUserNameLabel.text = user.name
        loadFriendImage(user: user)
    }
    
    func loadFriendImage(user: User) {
        UserProfileViewModel.shared.loadProfilePicture(user: user)  { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.friendImageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}
