//
//  ConstantVariables.swift
//  social_network_app
//
//  Created by admin on 7/18/22.
//

import Foundation

class ConstantVariables {
    static let postCellNib = "PostTableViewCell"
    static let postCellIdentifier = "PostCell"
    
    enum FriendRequestState: String {
        case accepted = "1"
        case declined = "2"
        case pending = "3"
    }
}
