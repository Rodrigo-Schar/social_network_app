//
//  UserProfileViewModel.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import Foundation
import CoreData

class UserProfileViewModel {
    
    static let shared = UserProfileViewModel()
    
    func getDatauser() -> UsersLocal? {
        let user: UsersLocal?
        let context = CoreDataManager.shared.getContext()
        let fetchRequest = NSFetchRequest<UsersLocal>(entityName: "UsersLocal")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray:["isLoggedIn", true])
        
        let results = try?context.fetch(fetchRequest)
        user = results?.first

        return user
    }
    
    func setLogOut(email: String) {
        let context = CoreDataManager.shared.getContext()
        let fetchRequest = NSFetchRequest<UsersLocal>(entityName: "UsersLocal")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray:["email", email])

        do {
            let results = try context.fetch(fetchRequest)
            results.first?.isLoggedIn = false
            try? context.save()
            
        }catch let error {
            print("Error....: \(error)")
        }
    }
}
