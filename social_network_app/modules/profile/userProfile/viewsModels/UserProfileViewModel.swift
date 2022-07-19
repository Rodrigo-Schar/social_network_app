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
    
    let firebaseManager = FirebaseManager.shared
    static let shared = UserProfileViewModel()
    
    let db = Firestore.firestore()
    var userLogin: User?
    var user: User?
    var myPosts = [Post]()
    var postDetail = [Post]()
    
    func getDataUser() {
        if let userData = userLogin {
            getDataUserNetwork(id: userData.id)
        } else {
            let userLocal = getDataUserLocal()
            guard let userId = userLocal?.id else { return }
            getDataUserNetwork(id: userId)
        }
    }
    
    func getDataUserNetwork(id: String) {
        firebaseManager.getDocumentsByParameter(type: User.self, forCollection: .users, field: "id", parameter: id) { result in
            switch result {
                case .success(let posts):
                    if let userData = posts.first {
                        self.user = userData
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getDataUserLocal() -> UsersLocal? {
        let user: UsersLocal?
        let context = CoreDataManager.shared.getContext()
        let fetchRequest = NSFetchRequest<UsersLocal>(entityName: "UsersLocal")
        fetchRequest.fetchLimit = 1
                
        let results = try?context.fetch(fetchRequest)
        user = results?.first

        return user
    }
    
    func loadMyPosts(ownerId: String) {
        firebaseManager.getDocumentsByParameter(type: Post.self, forCollection: .posts, field: "ownerId", parameter: ownerId) { result in
            switch result {
                case .success(let posts):
                    self.myPosts = posts
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
                    //self.getDataUserNetwork()
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
    
    func addPostForDetail(post: Post) {
        postDetail.removeAll()
        postDetail.append(post)
    }
}
