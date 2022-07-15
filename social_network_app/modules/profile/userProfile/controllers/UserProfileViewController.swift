//
//  UserProfileViewController.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import UIKit
import FirebaseStorage
import SwiftUI

class UserProfileViewController: ImagePickerHelperViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addProfileImageButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataUser()
        loadProfilePicture()
       
    }
    
    func loadDataUser() {
        if let userData = UserProfileViewModel.shared.users.first {
            nameLabel.text = userData.name
            nicknameLabel.text = userData.nickname
            emailLabel.text = userData.email
        }
    }
    
    func loadProfilePicture() {
        if let user = UserProfileViewModel.shared.users.first, !user.imageUrl.isEmpty {
            UserProfileViewModel.shared.loadProfilePicture(user: user) { result in
                
                switch result {
                    case .success(let data):
                        self.profileImageView.image = UIImage(data: data)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }

    @IBAction func addProfileImage(_ sender: Any) {
        showAddImageOptionAlert()
    }
    
    override func saveSelectedImageInFirebase(withExtension: String, data: Data) {
        if let user = UserProfileViewModel.shared.users.first {
            UserProfileViewModel.shared.addProfilePicture(data: data, user: user)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            guard let email = self.emailLabel.text else { return }
            UserProfileViewModel.shared.setLogOut(email: email)
            let sceneDelegate = SceneDelegate.shared
            sceneDelegate?.setupRootControllerIfNeeded(validUser: false)
        })
                
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Canceled")
        }
                
        dialogMessage.addAction(confirm)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
