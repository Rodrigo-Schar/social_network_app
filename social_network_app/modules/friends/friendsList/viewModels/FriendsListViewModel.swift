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
    var users = [User]()
    
    func loadFriends() {
        if let userData = UserProfileViewModel.shared.user {
            firebaseManager.listenCollectionChangesBytwoParameter(type: FriendRequest.self, collection: .friendRequests, field1: "userReceiverId", field2: "state", parameter1: userData.id, parameter2: ConstantVariables.FriendRequestState.accepted.rawValue) { result in
                switch result {
                    case .success(let requests):
                        self.friends = requests
                    case .failure(let error):
                        print(error)
                }
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
}
