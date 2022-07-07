//
//  LoginViewModel.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import Foundation
import CoreData

class LoginViewModel {
    
    static let shared = LoginViewModel()
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void ) {
        setLoggedIn(email: email)
        AuthFirebaseManager.shared.login(email: email, password: password) { result in
            completion(result)
        }
    }
    
    func verifyValidUser() -> Bool {
        var validUser = true
        let context = CoreDataManager.shared.getContext()
        let fetchRequest = NSFetchRequest<UsersLocal>(entityName: "UsersLocal")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray:["isLoggedIn", true])

        do {
            let results = try context.fetch(fetchRequest)
            if (results.count == 0){
                validUser = false
            } else {
                validUser = true
            }
        }catch let error {
            print("Error....: \(error)")
        }
        
        return validUser
    }
    
    func setLoggedIn(email: String) {
        let context = CoreDataManager.shared.getContext()
        let fetchRequest = NSFetchRequest<UsersLocal>(entityName: "UsersLocal")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray:["email", email])

        do {
            let results = try context.fetch(fetchRequest)
            results.first?.isLoggedIn = true
            try? context.save()
            
        }catch let error {
            print("Error....: \(error)")
        }
    }
}
