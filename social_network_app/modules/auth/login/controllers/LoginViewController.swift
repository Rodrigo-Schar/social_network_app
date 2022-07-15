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
    @IBOutlet weak var viewConstrait: NSLayoutConstraint!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardNotification()
    }
    
    func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func verifyTextFields() -> Bool {
        var isValid = true
        if emailTextField.text!.isEmpty {
            isValid = false
            emailErrorLabel.isHidden = false
        }
        if passwordTextField.text!.isEmpty {
            isValid = false
            passwordErrorLabel.isHidden = false
        }
        
        return isValid
    }
    
    @IBAction func signIn(_ sender: Any) {
        if verifyTextFields() {
            let email = emailTextField.text ?? ""
            let pass = passwordTextField.text ?? ""
            
            LoginViewModel.shared.login(email: email, password: pass) { result in
                switch result {
                    case .success(let user):
                        LoginViewModel.shared.addUserLocal(user: user)
                        SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: true)
                        self.errorLabel.isHidden = true
                    case .failure(let error):
                        print("Error", error)
                        self.errorLabel.text = "Invalid Email or Password"
                        self.errorLabel.isHidden = false
                    }
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
    
    @objc func keyBoardWillShow(_ notificacion: Notification){
        guard let userInfo = notificacion.userInfo,
              let keyboardframe = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        viewConstrait.constant = keyboardframe.size.height
        UIView.animate(withDuration: duration){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyBoardWillHide(_ notificacion: Notification){
        guard let userInfo = notificacion.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        viewConstrait.constant = 0
        UIView.animate(withDuration: duration){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}
