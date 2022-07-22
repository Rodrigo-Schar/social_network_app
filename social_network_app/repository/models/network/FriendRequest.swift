//
//  FriendRequest.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import Foundation

struct FriendRequest: Codable, BaseModel {
    var id: String
    let userSenderId: String
    let userReceiverId: String
    var state: String
    let createdAt: Double
    let updatedAt: Double
}
