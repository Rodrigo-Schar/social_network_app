//
//  ChatListViewModel.swift
//  social_network_app
//
//  Created by admin on 7/23/22.
//

import Foundation
import FirebaseFirestore

class ChatListViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = ChatListViewModel()
    
    var chats = [Chat]()
    var users = [User]()
    
    func getChatIdBySender(senderId: String, completion: ( () -> Void )? ) {
        firebaseManager.listenCollectionChangesByParameter(type: Chat.self, collection: .chats, field: "participant1Id", parameter: senderId) { result in
            switch result {
                case .success(let chats):
                    self.chats.removeAll()
                    self.chats = chats
                    self.getChatIdByReceiver(receiverId: senderId) {result in
                        switch result {
                            case .success(let chats):
                                if !chats.isEmpty {
                                    for chat in chats {
                                        self.chats.append(chat)
                                    }
                                }
                                completion?()
                            case .failure(let error):
                                print(error)
                            }
                        }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getChatIdByReceiver(receiverId: String, completion: @escaping ( Result<[Chat], Error>) -> Void) {
        firebaseManager.listenCollectionChangesByParameter(type: Chat.self, collection: .chats, field: "participant2Id", parameter: receiverId) { result in
            switch result {
                case .success(let chats):
                    completion(.success(chats))
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getUserChat(userId: String, completion: ( () -> Void )? ) {
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
