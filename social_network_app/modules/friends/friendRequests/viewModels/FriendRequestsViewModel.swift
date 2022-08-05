//
//  FriendRequestsViewModel.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import Foundation
import FirebaseFirestore

class FriendRequestsViewModel {
    
    let firebaseManager = FirebaseManager.shared
    static let shared = FriendRequestsViewModel()
    
    var friendRequests = [FriendRequest]()
    var users = [User]()
    
    func loadFriendsRequests(completion: ( () -> Void )? ) {
        if let userData = UserProfileViewModel.shared.user {
            firebaseManager.listenCollectionChangesBytwoParameter(type: FriendRequest.self, collection: .friendRequests, field1: "userReceiverId", field2: "state", parameter1: userData.id, parameter2: ConstantVariables.FriendRequestState.pending.rawValue) { result in
                switch result {
                    case .success(let requests):
                        self.friendRequests = requests
                        completion?()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func getUserRequest(userId: String, completion: ( () -> Void )? ) {
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
    
    func confirmFriendRequest(friendRequest: FriendRequest, completion: ( () -> Void )? ) {
        let request = FriendRequest(id: friendRequest.id, userSenderId: friendRequest.userSenderId, userReceiverId: friendRequest.userReceiverId, state: ConstantVariables.FriendRequestState.accepted.rawValue, createdAt: friendRequest.createdAt, updatedAt: DateHelper.dateToDouble(date: Date()))
        
        firebaseManager.updateDocument(document: request, collection: .friendRequests) { result in
            switch result {
                case .success(let request):
                    completion?()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func declineFriendRequest(friendRequest: FriendRequest, completion: ( () -> Void )? ) {
        let request = FriendRequest(id: friendRequest.id, userSenderId: friendRequest.userSenderId, userReceiverId: friendRequest.userReceiverId, state: ConstantVariables.FriendRequestState.declined.rawValue, createdAt: friendRequest.createdAt, updatedAt: DateHelper.dateToDouble(date: Date()))
        
        firebaseManager.updateDocument(document: request, collection: .friendRequests) { result in
            switch result {
                case .success(let request):
                    completion?()
                case .failure(let error):
                    print(error)
            }
        }
    }
}
