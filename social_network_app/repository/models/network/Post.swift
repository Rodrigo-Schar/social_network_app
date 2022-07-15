//
//  Post.swift
//  social_network_app
//
//  Created by admin on 7/14/22.
//

import Foundation

struct Post: Codable, BaseModel {
    var id: String
    let title: String
    let description: String
    let imageUrl: String
    let projectUrl: String
    let likes: Double
    let ownerId: String
    let createdAt: Double
    let updatedAt: Double
}
