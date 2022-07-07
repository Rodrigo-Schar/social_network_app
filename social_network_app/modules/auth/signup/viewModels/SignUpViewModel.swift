//
//  SignUpViewModel.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import Foundation
import CoreData

class SignUpViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = SignUpViewModel()
    
    func addUser(name: String, nickname: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void ) {
        let userID = firebaseManager.getDocID(forCollection: .users)
        let user = User(id: userID, name: name, nickname: nickname, email: email, password: password, imageUrl: "", createdAt: Date(), updatedAt: Date())
        addUserLocal(user: user)
        
        firebaseManager.addDocument(document: user, collection: .users) { result in
            completion(result)
        }
    }
    
    private func addUserLocal(user: User){
        let context = CoreDataManager.shared.getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "UsersLocal", in: context) else { return }
        guard let userLocal = NSManagedObject(entity: entity, insertInto: context) as? UsersLocal else { return }
        
        userLocal.id = user.id
        userLocal.name = user.name
        userLocal.nickname = user.nickname
        userLocal.email = user.email
        userLocal.password = user.password
        userLocal.imageUrl = user.imageUrl
        userLocal.createdAt = user.createdAt
        userLocal.updatedAt = user.updatedAt
        userLocal.isLoggedIn = false
        
        do {
            try context.save()
            print("created")
            
        } catch(let err) {
            print("Error", err)
        }
    }
}
