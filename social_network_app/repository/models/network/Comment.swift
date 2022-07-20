//
//  Comment.swift
//  social_network_app
//
//  Created by admin on 7/19/22.
//

import Foundation

struct Comment: Codable, BaseModel {
    var id: String
    let description: String
    let ownerId: String
    let postId: String
    let createdAt: Double
    let updatedAt: Double
}
