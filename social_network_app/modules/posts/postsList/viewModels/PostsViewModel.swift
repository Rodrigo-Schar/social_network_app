//
//  PostsViewModel.swift
//  social_network_app
//
//  Created by admin on 7/14/22.
//

import Foundation

class PostsViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = PostsViewModel()
    
    var reloadData: (() -> Void)?
    
    var posts = [Post]()
    
    func addNewPost(title: String, description: String, projecUrl: String, imageUrl: String, ownerId: String, completion: @escaping (Result<Post, Error>) -> Void ) {
        let postID = firebaseManager.getDocID(forCollection: .posts)
        let post = Post(id: postID, title: title, description: description, imageUrl: imageUrl, projectUrl: projecUrl, likes: 1, ownerId: ownerId, createdAt: 1.0, updatedAt: 1.0)
        
        firebaseManager.addDocument(document: post, collection: .posts) { result in
            completion(result)
        }
    }
    
    func loadPosts() {
        firebaseManager.getDocuments(type: Post.self, forCollection: .posts) { result in
            switch result {
            case .success(let posts):
                print(posts)
                self.posts = posts
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
