//
//  Reaction.swift
//  social_network_app
//
//  Created by admin on 7/19/22.
//

import Foundation

struct Reaction: Codable, BaseModel {
    var id: String
    let postId: String
    let userId: String
    let reaction: Double
    let createdAt: Double
    let updatedAt: Double
}
