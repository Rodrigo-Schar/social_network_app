//
//  PostsViewModel.swift
//  social_network_app
//
//  Created by admin on 7/14/22.
//

import Foundation
import FirebaseStorage

class PostsViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = PostsViewModel()
    
    var reloadData: (() -> Void)?
    
    var posts = [Post]()
    var postsOriginalList = [Post]()
    var postDetail = [Post]()
    var dataImage = Data()
    
    func loadPosts() {
        firebaseManager.getDocuments(type: Post.self, forCollection: .posts) { result in
            switch result {
            case .success(let posts):
                self.postsOriginalList = posts
                self.posts = posts
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addNewPost(title: String, description: String, projecUrl: String, ownerId: String, completion: @escaping (Result<Post, Error>) -> Void ) {
        let postId = firebaseManager.getDocID(forCollection: .posts)
        let pathImage = addPostImage(data: dataImage, postId: postId)
        
        let post = Post(id: postId, title: title, description: description, imageUrl: pathImage, projectUrl: projecUrl, likes: 1, ownerId: ownerId, createdAt: 1.0, updatedAt: 1.0)
        
        firebaseManager.addDocument(document: post, collection: .posts) { result in
            completion(result)
        }
    }
    
    func editPost(postId: String, title: String, description: String, projecUrl: String, ownerId: String, completion: @escaping (Result<Post, Error>) -> Void) {
        
        let pathImage = addPostImage(data: dataImage, postId: postId)
        let post = Post(id: postId, title: title, description: description, imageUrl: pathImage, projectUrl: projecUrl, likes: 1, ownerId: ownerId, createdAt: 1.0, updatedAt: 1.0)
        
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
    
    func loadPostImage(post: Post, completion: @escaping (Result<Data, Error>) -> Void ) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(post.imageUrl)
        fileRef.getData(maxSize: 5 * 1024 * 1024) { result in
            completion(result)
        }
    }
    
    func searchPost(text: String) {
        posts = posts.filter({
            $0.title.contains(text.lowercased())
        })
    }
    
    func addPostForDetail(post: Post) {
        postDetail.removeAll()
        postDetail.append(post)
    }
    
    
    
}
