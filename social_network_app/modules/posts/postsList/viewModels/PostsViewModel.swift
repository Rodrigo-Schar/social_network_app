//
//  PostsViewModel.swift
//  social_network_app
//
//  Created by admin on 7/14/22.
//

import Foundation
import FirebaseStorage

enum TypeReactions: Int {
    case like = 1
    case dislike = 2
}

class PostsViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = PostsViewModel()
    
    var reloadData: (() -> Void)?
    
    var posts = [Post]()
    var postsOriginalList = [Post]()
    
    func loadPosts(completion: ( () -> Void )?) {
        firebaseManager.listenCollectionChanges(type: Post.self, collection: .posts) { result in
            switch result {
            case .success(let posts):
                self.postsOriginalList = posts
                self.posts = posts
                completion?()
            case .failure(let error):
                print(error)
            }
        }
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
    
    func addPostReaction(post: Post, typeReaction: TypeReactions) {
        guard let userData = UserProfileViewModel.shared.user else { return }
        
        firebaseManager.getDocumentsByTwoParameter(type: Reaction.self, forCollection: .reactions, field1: "userId", field2: "postId", parameter1: userData.id, parameter2: post.id) { result in
            switch result {
                case .success(let reactions):
                    if reactions.count == 0 {
                        self.addNewReaction(post: post, userId: userData.id, typeReaction: typeReaction)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func addNewReaction(post: Post, userId: String, typeReaction: TypeReactions) {
        let reactionId = firebaseManager.getDocID(forCollection: .reactions)
        let reaction = Reaction(id: reactionId, postId: post.id, userId: userId, reaction: Double(typeReaction.rawValue), createdAt: DateHelper.dateToDouble(date: Date()), updatedAt: DateHelper.dateToDouble(date: Date()))
        firebaseManager.addDocument(document: reaction, collection: .reactions) { result in
            switch result {
            case .success(let reaction):
                self.editPostReaction(post: post, typeReaction: typeReaction)
                print(reaction)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func editPostReaction(post: Post, typeReaction: TypeReactions) {
        if typeReaction.rawValue == 1 {
            let count = post.likes + 1
            let edPost = Post(id: post.id, title: post.title, description: post.description, imageUrl: post.imageUrl, projectUrl: post.projectUrl, likes: count, dislikes: post.dislikes, ownerId: post.ownerId, createdAt: post.createdAt, updatedAt: DateHelper.dateToDouble(date: Date()))
            self.updatePostReactions(post: edPost)
            
        } else {
            let count = post.dislikes + 1
            let edPost = Post(id: post.id, title: post.title, description: post.description, imageUrl: post.imageUrl, projectUrl: post.projectUrl, likes: post.likes, dislikes: count, ownerId: post.ownerId, createdAt: post.createdAt, updatedAt: DateHelper.dateToDouble(date: Date()))
            self.updatePostReactions(post: edPost)
        }
    }
    
    func updatePostReactions(post: Post) {
        firebaseManager.updateDocument(document: post, collection: .posts) { result in
            switch result {
            case .success(let post):
                print(post)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func verfiyPostReactin(postId: String, userId: String, completion: @escaping (Result<[Reaction], Error>) -> Void ) {
        firebaseManager.getDocumentsByTwoParameter(type: Reaction.self, forCollection: .reactions, field1: "postId", field2: "userId", parameter1: postId, parameter2: userId) { result in
                completion(result)
        }
    }
}
