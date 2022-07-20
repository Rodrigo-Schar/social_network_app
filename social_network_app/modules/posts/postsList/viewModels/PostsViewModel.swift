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
    var postDetail = [Post]()
    var dataImage = Data()
    var comments = [Comment]()
    
    func loadPosts() {
        firebaseManager.listenCollectionChanges(type: Post.self, collection: .posts) { result in
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
        
        let post = Post(id: postId, title: title, description: description, imageUrl: pathImage, projectUrl: projecUrl, likes: 0, dislikes: 0, ownerId: ownerId, createdAt: 1.0, updatedAt: 1.0)
        
        firebaseManager.addDocument(document: post, collection: .posts) { result in
            completion(result)
        }
    }
    
    func editPost(postId: String, title: String, description: String, projecUrl: String, likes: Double, dislikes: Double, ownerId: String, completion: @escaping (Result<Post, Error>) -> Void) {
        
        let pathImage = addPostImage(data: dataImage, postId: postId)
        let post = Post(id: postId, title: title, description: description, imageUrl: pathImage, projectUrl: projecUrl, likes: likes, dislikes: dislikes, ownerId: ownerId, createdAt: 1.0, updatedAt: 1.0)
        
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
        let reaction = Reaction(id: reactionId, postId: post.id, userId: userId, reaction: Double(typeReaction.rawValue), createdAt: 1.0, updatedAt: 1.0)
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
            let edPost = Post(id: post.id, title: post.title, description: post.description, imageUrl: post.imageUrl, projectUrl: post.projectUrl, likes: count, dislikes: post.dislikes, ownerId: post.ownerId, createdAt: post.createdAt, updatedAt: post.updatedAt)
            self.updatePostReactions(post: edPost)
            
        } else {
            let count = post.dislikes + 1
            let edPost = Post(id: post.id, title: post.title, description: post.description, imageUrl: post.imageUrl, projectUrl: post.projectUrl, likes: post.likes, dislikes: count, ownerId: post.ownerId, createdAt: post.createdAt, updatedAt: post.updatedAt)
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
    
    func loadComments(postId: String) {
        firebaseManager.listenCollectionChangesByParameter(type: Comment.self, collection: .comments, field: "postId", parameter: postId) { result in
            switch result {
                case .success(let comments):
                    self.comments = comments
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func addNewComment(postId: String, ownerId: String, description: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        let commentId = firebaseManager.getDocID(forCollection: .comments)
        let comment = Comment(id: commentId, description: description, ownerId: ownerId, postId: postId, createdAt: 1.0, updatedAt: 1.0)
        firebaseManager.addDocument(document: comment, collection: .comments) { result in
            completion(result)
        }
    }
    
    
    
}
