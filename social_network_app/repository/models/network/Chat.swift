//
//  Chat.swift
//  social_network_app
//
//  Created by admin on 7/23/22.
//

import Foundation

struct Chat: Codable, BaseModel {
    var id: String
    let participant1Id: String
    let participant2Id: String
    let createdAt: Double
    let updatedAt: Double
}
