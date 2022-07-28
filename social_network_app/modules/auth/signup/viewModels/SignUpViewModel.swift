//
//  SignUpViewModel.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import Foundation
import CoreData

class SignUpViewModel {
    let firebaseManager = FirebaseManager.shared
    static let shared = SignUpViewModel()
    
    func addUser(name: String, nickname: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void ) {
        let userID = firebaseManager.getDocID(forCollection: .users)
        let user = User(id: userID, name: name, nickname: nickname, email: email, password: password, imageUrl: "", createdAt: DateHelper.dateToDouble(date: Date()), updatedAt: DateHelper.dateToDouble(date: Date()))
        
        firebaseManager.addDocument(document: user, collection: .users) { result in
            completion(result)
        }
    }
}
