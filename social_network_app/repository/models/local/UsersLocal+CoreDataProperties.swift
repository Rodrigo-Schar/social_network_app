//
//  UsersLocal+CoreDataProperties.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//
//

import Foundation
import CoreData


extension UsersLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersLocal> {
        return NSFetchRequest<UsersLocal>(entityName: "UsersLocal")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nickname: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isLoggedIn: Bool

}

extension UsersLocal : Identifiable {

}
