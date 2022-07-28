//
//  AddFriendsViewModel.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import Foundation
import FirebaseFirestore

class AddFriendsViewModel {
    
    let firebaseManager = FirebaseManager.shared
    static let shared = AddFriendsViewModel()
    
    var usersList = [User]()
    
    func searchFriend(text: String, completion: ( () -> Void )? ) {
        firebaseManager.listenCollectionChangesByParameter(type: User.self, collection: .users, field: "name", parameter: text) { result in
            switch result {
            case .success(let users):
                self.usersList = users
                completion?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendfriendRequest(userSenderId: String, userReceiverId: String, completion: ( () -> Void )?) {
        let requestId = firebaseManager.getDocID(forCollection: .friendRequests)
        let request = FriendRequest(id: requestId, userSenderId: userSenderId, userReceiverId: userReceiverId, state: ConstantVariables.FriendRequestState.pending.rawValue, createdAt: DateHelper.dateToDouble(date: Date()), updatedAt: DateHelper.dateToDouble(date: Date()))
        
        firebaseManager.addDocument(document: request, collection: .friendRequests) { result in
            switch result {
                case .success(let friendrequest):
                    self.usersList.removeAll()
                    completion?()
                case .failure(let error):
                    print(error)
            }
        }
    }
}
