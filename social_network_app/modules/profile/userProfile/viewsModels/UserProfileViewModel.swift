//
//  UserProfileViewModel.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import Foundation
import CoreData
import FirebaseFirestore
import FirebaseStorage

class UserProfileViewModel {
    
    static let shared = UserProfileViewModel()
    
    let db = Firestore.firestore()
    var users = [User]()
    
    func getDataUserNetwork() {
        FirebaseManager.shared.getDocuments(type: User.self, forCollection: FirebaseCollections.users) { result in
            switch result {
                case .success(let users):
                    self.users.removeAll()
                    self.users = users
                    print(self.users)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func addProfilePicture(data: Data, user: User) {
        //get the storage refrence
        let storageRef = Storage.storage().reference()
        //specify the file path and name
        let path = "ProfilePictures/\(user.id).jpg"
        let fileRef = storageRef.child(path)
        let uploadImage = fileRef.putData(data) { metadata, error in
            if error == nil && metadata != nil {
                let userEd = User(id: user.id, name: user.name, nickname: user.nickname, email: user.email, password: user.password, imageUrl: path, createdAt: user.createdAt, updatedAt: 1.0)
                FirebaseManager.shared.updateDocument(document: userEd, collection: .users) { result in
                    self.getDataUserNetwork()
                }
            }
        }
    }
    
    func loadProfilePicture(user: User, completion: @escaping (Result<Data, Error>) -> Void ) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(user.imageUrl)
        fileRef.getData(maxSize: 5 * 1024 * 1024) { result in
            completion(result)
        }
    }
    
    func getDataUserLocal() -> UsersLocal? {
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
            if let user = results.first {
                context.delete(user)
                try? context.save()
            }
            
        }catch let error {
            print("Error....: \(error)")
        }
    }
}
