//
//  ReceiverTableViewCell.swift
//  social_network_app
//
//  Created by admin on 7/23/22.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(message: Message) {
        self.messageView.layer.cornerRadius = 10
        self.messageLabel.text = message.content
    }
    
}
