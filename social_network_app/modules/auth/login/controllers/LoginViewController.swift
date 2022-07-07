//
//  LoginViewViewController.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signIn(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let pass = passwordTextField.text ?? ""
        
        LoginViewModel.shared.login(email: email, password: pass) { result in
            switch result {
                case .success(let user):
                    print("User", user)
                    SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: true)
                    self.errorLabel.isHidden = true
                case .failure(let error):
                    print("Error", error)
                    self.errorLabel.text = "Invalid Email or Password"
                    self.errorLabel.isHidden = false
                }
            }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let vc = SignUpViewController()
        show(vc, sender: nil)
    }
    
    func verifyValidUser() -> Bool {
        let validUser = LoginViewModel.shared.verifyValidUser()
        return validUser
    }
}
