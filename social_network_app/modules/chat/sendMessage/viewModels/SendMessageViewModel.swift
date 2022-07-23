//
//  SendMessageViewModel.swift
//  social_network_app
//
//  Created by admin on 7/23/22.
//

import Foundation
import FirebaseFirestore

class SendMessageViewModel {
    
    let firebaseManager = FirebaseManager.shared
    static let shared = SendMessageViewModel()
    
    var userReceiver: User?
    var messages = [Message]()
    var chats = [Chat]()
    
    func getChatIdByReceiver(receiverId: String, completion: ( () -> Void )? ) {
        if let userData = UserProfileViewModel.shared.user {
            firebaseManager.listenCollectionChangesBytwoParameter(type: Chat.self, collection: .chats, field1: "participant1Id", field2: "participant2Id", parameter1: receiverId, parameter2: userData.id) { result in
                switch result {
                    case .success(let chats):
                        if chats.isEmpty {
                            self.getChatIdBySender(senderId: userData.id, receiverId: receiverId) {result in
                                switch result {
                                case .success(let chats):
                                    if chats.isEmpty {
                                        self.createChat(senderId: userData.id, receiverId: receiverId) { result in
                                            switch result {
                                                case .success(let chat):
                                                    self.chats.append(chat)
                                                    completion?()
                                                case.failure(let error):
                                                    print(error)
                                            }
                                        }
                                    } else {
                                        self.chats = chats
                                        completion?()
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        } else {
                            self.chats = chats
                            completion?()
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func getChatIdBySender(senderId: String, receiverId: String, completion: @escaping ( Result<[Chat], Error>) -> Void) {
        firebaseManager.listenCollectionChangesBytwoParameter(type: Chat.self, collection: .chats, field1: "participant1Id", field2: "participant2Id", parameter1: senderId, parameter2: receiverId) { result in
            switch result {
                case .success(let chats):
                    completion(.success(chats))
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func createChat(senderId: String, receiverId: String, completion: @escaping ( Result<Chat, Error>) -> Void) {
        let chatId = firebaseManager.getDocID(forCollection: .chats)
        let chat = Chat(id: chatId, participant1Id: senderId, participant2Id: receiverId, createdAt: 1.0, updatedAt: 1.0)
        firebaseManager.addDocument(document: chat, collection: .chats) { result in
            switch result {
                case .success(let chat):
                    completion(.success(chat))
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func loadMessages(chatId: String, completion: ( () -> Void )? ) {
        firebaseManager.listenCollectionChangesByParameter(type: Message.self, collection: .messages, field: "chatId", parameter: chatId) { result in
            switch result {
                case .success(let messages):
                    self.messages = messages
                    completion?()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func sendMessage(chatId: String, message: String, senderId: String, completion: ( () -> Void )? ) {
        let messageId = firebaseManager.getDocID(forCollection: .messages)
        let message = Message(id: messageId, content: message, chatId: chatId, userSenderId: senderId, createdAt: 1.0, updatedAt: 1.0)
        
        firebaseManager.addDocument(document: message, collection: .messages) { result in
            switch result {
                case .success(let message):
                    self.messages.append(message)
                    completion?()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}
