//
//  User.swift
//  social_network_app
//
//  Created by admin on 6/29/22.
//

import Foundation

struct User: Codable, BaseModel {
    var id: String
    let name: String
    let nickname: String
    let email: String
    let password: String
    let imageUrl: String
    let createdAt: Double
    let updatedAt: Double
}
