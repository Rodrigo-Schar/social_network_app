//
//  Message.swift
//  social_network_app
//
//  Created by admin on 7/23/22.
//

import Foundation

struct Message: Codable, BaseModel {
    var id: String
    let content: String
    let chatId: String
    let userSenderId: String
    let createdAt: Double
    let updatedAt: Double
}
