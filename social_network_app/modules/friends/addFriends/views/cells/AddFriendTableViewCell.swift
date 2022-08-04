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
        userImageView.layer.borderWidth = 0.2
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.cornerRadius = userImageView.bounds.size.width / 2.0
        self.userNameLabel.text = user.name
        loadUserImage(user: user)
    }
    
    func loadUserImage(user: User) {
        UserProfileViewModel.shared.loadProfilePicture(user: user)  { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.userImageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}
