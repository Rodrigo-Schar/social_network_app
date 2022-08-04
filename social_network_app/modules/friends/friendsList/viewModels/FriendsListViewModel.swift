//
//  FriendsListViewModel.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import Foundation
import FirebaseFirestore

class FriendsListViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = FriendsListViewModel()
    
    var friends = [FriendRequest]()
    var friendsByReceiver = [FriendRequest]()
    var friendsBySender = [FriendRequest]()
    var users = [User]()
    
    func loadFriends(completion: ( () -> Void )?) {
        if let userData = UserProfileViewModel.shared.user {
            firebaseManager.listenCollectionChangesBytwoParameter(type: FriendRequest.self, collection: .friendRequests, field1: "userReceiverId", field2: "state", parameter1: userData.id, parameter2: ConstantVariables.FriendRequestState.accepted.rawValue) { result in
                switch result {
                    case .success(let requests):
                        self.friendsByReceiver = requests
                        self.loadFriendsBySender(userSenderId: userData.id) {
                        completion?() }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func loadFriendsBySender(userSenderId: String, completion: ( () -> Void )?) {
        firebaseManager.listenCollectionChangesBytwoParameter(type: FriendRequest.self, collection: .friendRequests, field1: "userSenderId", field2: "state", parameter1: userSenderId, parameter2: ConstantVariables.FriendRequestState.accepted.rawValue) { result in
                switch result {
                    case .success(let requests):
                        self.friendsBySender = requests
                        self.friends = self.friendsByReceiver + self.friendsBySender
                        completion?()
                    case .failure(let error):
                        print(error)
                }
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
    
    func deleteFriendBySenderId(userSenderId: String, userId: String) {
        firebaseManager.getDocumentsByTwoParameter(type: FriendRequest.self, forCollection: .friendRequests, field1: "userSenderId", field2: "userReceiverId", parameter1: userSenderId, parameter2: userId) { result in
            switch result {
                case .success(let requests):
                    if !requests.isEmpty {
                        guard let request = requests.first else { return }
                        self.friends.removeAll()
                        self.firebaseManager.removeDocument(documentID: request.id, collection: .friendRequests) { result in }
                    } else {
                        self.deleteFriendBySenderId(userSenderId: userId, userId: userSenderId)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}
