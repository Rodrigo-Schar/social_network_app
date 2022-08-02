//
//  SignUpViewController.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var viewConstrait: NSLayoutConstraint!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign Up"
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
        if nameTextField.text!.isEmpty {
            isValid = false
            nameErrorLabel.isHidden = false
        }
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
    
    @IBAction func signUp(_ sender: Any) {
        if verifyTextFields() {
            let name = nameTextField.text ?? ""
            let nickname = nicknameTextField.text ?? ""
            let email = emailTextField.text ?? "test@user.com"
            let pass = passwordTextField.text ?? "pass"
            SVProgressHUD.show()
            
            SignUpViewModel.shared.addUser(name: name, nickname: nickname, email: email, password: pass) { result in
                switch result {
                    case .success(let user):
                        print("Success", user)
                        SVProgressHUD.dismiss()
                        self.showToast(message: "You have successfully registered", seconds: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        print("Error", error)
                }
            }
        }
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
