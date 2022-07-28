//
//  NewEditPostViewModel.swift
//  social_network_app
//
//  Created by admin on 7/25/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class NewEditPostViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = NewEditPostViewModel()
    
    var dataImage = Data()
    
    func addNewPost(title: String, description: String, projecUrl: String, ownerId: String, completion: @escaping (Result<Post, Error>) -> Void ) {
        let postId = firebaseManager.getDocID(forCollection: .posts)
        let pathImage = addPostImage(data: dataImage, postId: postId)
        
        let post = Post(id: postId, title: title, description: description, imageUrl: pathImage, projectUrl: projecUrl, likes: 0, dislikes: 0, ownerId: ownerId, createdAt: DateHelper.dateToDouble(date: Date()), updatedAt: DateHelper.dateToDouble(date: Date()))
        
        firebaseManager.addDocument(document: post, collection: .posts) { result in
            completion(result)
        }
    }
    
    func editPost(postId: String, title: String, description: String, projecUrl: String, likes: Double, dislikes: Double, ownerId: String, created: Double, completion: @escaping (Result<Post, Error>) -> Void) {
        
        let pathImage = addPostImage(data: dataImage, postId: postId)
        let post = Post(id: postId, title: title, description: description, imageUrl: pathImage, projectUrl: projecUrl, likes: likes, dislikes: dislikes, ownerId: ownerId, createdAt: created, updatedAt: DateHelper.dateToDouble(date: Date()))
        
        firebaseManager.updateDocument(document: post, collection: .posts) { result in
            completion(result)
        }
    }
    
    func addPostImage(data: Data, postId: String) -> String {
        let storageRef = Storage.storage().reference()

        let path = "PostImages/\(postId).jpg"
        let fileRef = storageRef.child(path)
        
        fileRef.putData(data) { metadata, error in
            if error == nil && metadata != nil {
                
            }
        }
        
        return path
    }
    
    func deletePost(postId: String, completion: ( () -> Void )?) {
        firebaseManager.removeDocument(documentID: postId, collection: .posts) { result in
            switch result {
            case .success(let string):
                print(string)
                completion?()
            case .failure(let error):
                print(error)
            }
        }
    }
}
