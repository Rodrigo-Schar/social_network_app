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
    
    var users = [UsersLocal]()
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void ) {
        
        AuthFirebaseManager.shared.login(email: email, password: password) { result in
            completion(result)
        }
    }
    
    func verifyValidUser() -> Bool {
        var validUser = true
        let context = CoreDataManager.shared.getContext()
        let fetchRequest: NSFetchRequest<UsersLocal>
        fetchRequest = UsersLocal.fetchRequest()

        do {
            users = try context.fetch(fetchRequest)
            if (users.count == 0){
                validUser = false
            } else {
                validUser = true
            }
            
        } catch(let err) {
            print("Error", err)
        }
        
        return validUser
    }
    
    func addUserLocal(user: User){
        let context = CoreDataManager.shared.getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "UsersLocal", in: context) else { return }
        guard let userLocal = NSManagedObject(entity: entity, insertInto: context) as? UsersLocal else { return }
        
        userLocal.id = user.id
        userLocal.name = user.name
        userLocal.nickname = user.nickname
        userLocal.email = user.email
        userLocal.password = user.password
        userLocal.imageUrl = user.imageUrl
        userLocal.createdAt = Date()
        userLocal.updatedAt = Date()
        
        do {
            try context.save()
            print("created")
            
        } catch(let err) {
            print("Error", err)
        }
    }
    
    func setUser(user: User) {
        UserProfileViewModel.shared.userLogin = user
        UserProfileViewModel.shared.getDataUser()
    }
}
