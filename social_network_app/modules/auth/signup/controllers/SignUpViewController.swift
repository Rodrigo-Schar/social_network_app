//
//  SignUpViewController.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUp(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let nickname = nicknameTextField.text ?? ""
        let email = emailTextField.text ?? "test@user.com"
        let pass = passwordTextField.text ?? "pass"
                
        SignUpViewModel.shared.addUser(name: name, nickname: nickname, email: email, password: pass) { result in
            switch result {
                case .success(let user):
                    print("Success", user)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Error", error)
            }
        }
    }
}
