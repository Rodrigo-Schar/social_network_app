//
//  PostDetailViewModel.swift
//  social_network_app
//
//  Created by admin on 7/25/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class PostDetailViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = PostDetailViewModel()
    
    var postDetail = [Post]()
    var comments = [Comment]()
    var users = [User]()
    
    func addPostForDetail(post: Post) {
        postDetail.removeAll()
        postDetail.append(post)
    }
    
    func loadPostImage(post: Post, completion: @escaping (Result<Data, Error>) -> Void ) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(post.imageUrl)
        fileRef.getData(maxSize: 5 * 1024 * 1024) { result in
            completion(result)
        }
    }
    
    func loadComments(postId: String, completion: ( () -> Void )? ) {
        firebaseManager.listenCollectionChangesByParameter(type: Comment.self, collection: .comments, field: "postId", parameter: postId) { result in
            switch result {
                case .success(let comments):
                    self.comments = comments
                    completion?()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func addNewComment(postId: String, ownerId: String, description: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        let commentId = firebaseManager.getDocID(forCollection: .comments)
        let comment = Comment(id: commentId, description: description, ownerId: ownerId, postId: postId, createdAt: DateHelper.dateToDouble(date: Date()), updatedAt: DateHelper.dateToDouble(date: Date()))
        firebaseManager.addDocument(document: comment, collection: .comments) { result in
            completion(result)
        }
    }
    
    func getUserFriend(userId: String, completion: ( () -> Void )? ) {
        firebaseManager.getDocumentsByParameter(type: User.self, forCollection: .users, field: "id", parameter: userId) { result in
            switch result {
            case .success(let users):
                self.users = users
                completion?()
            case .failure(let error):
                print(error)
            }
        }
    }
}
