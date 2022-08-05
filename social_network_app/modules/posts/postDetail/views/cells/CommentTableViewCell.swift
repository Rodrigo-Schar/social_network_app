//
//  CommentTableViewCell.swift
//  social_network_app
//
//  Created by admin on 7/19/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(user: String, comment: Comment) {
        self.userNameLabel.text = user
        self.commentDescriptionLabel.text = comment.description
    }
    
}
