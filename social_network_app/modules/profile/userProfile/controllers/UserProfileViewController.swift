//
//  UserProfileViewController.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataUser()
    }
    
    func loadDataUser() {
        if let userData = UserProfileViewModel.shared.getDatauser() {
            nameLabel.text = userData.name
            nicknameLabel.text = userData.nickname
            emailLabel.text = userData.email
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
