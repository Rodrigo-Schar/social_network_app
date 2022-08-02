//
//  SendMessageViewController.swift
//  social_network_app
//
//  Created by admin on 7/23/22.
//

import UIKit

class SendMessageViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var userReceiverView: UIView!
    @IBOutlet weak var sendMessageView: UIView!
    
    lazy var viewModel = {
        SendMessageViewModel.shared
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpKeyboardNotification()
        loadUserReceiverData()
    }
    
    func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func loadUserReceiverData() {
        if let user = viewModel.userReceiver {
            loadUserImage(user: user)
            userNameLabel.text = user.name
            viewModel.getChatIdByReceiver(receiverId: user.id) {
                if let chat = self.viewModel.chats.first {
                    self.viewModel.loadMessages(chatId: chat.id) {
                        self.messagesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func setupView() {
        userView.layer.cornerRadius = userView.bounds.size.width / 2.0
        userImageView.layer.borderWidth = 0.2
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.cornerRadius = userImageView.bounds.size.width / 2.0
        sendMessageView.layer.cornerRadius = 10
        self.userReceiverView.layer.cornerRadius = 10
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        
        self.messagesTableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        self.messagesTableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
    }
    
    func loadUserImage(user: User) {
        UserProfileViewModel.shared.loadProfilePicture(user: user)  { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.userImageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let chat = self.viewModel.chats.first else { return }
        guard let userSender = UserProfileViewModel.shared.user else { return }
        guard let text = self.messageTextField.text else { return }
        
        viewModel.sendMessage(chatId: chat.id, message: text, senderId: userSender.id) {
            self.messageTextField.text = ""
            self.messagesTableView.reloadData()
        }
    }
    
    @objc func keyBoardWillShow(_ notificacion: Notification){
        guard let userInfo = notificacion.userInfo,
              let keyboardframe = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        viewConstraint.constant = (keyboardframe.size.height - 80)
        UIView.animate(withDuration: duration){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyBoardWillHide(_ notificacion: Notification){
        guard let userInfo = notificacion.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        viewConstraint.constant = 0
        UIView.animate(withDuration: duration){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

extension SendMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
    
        if let userSender = UserProfileViewModel.shared.user, userSender.id == message.userSenderId {
            let cell = self.messagesTableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as? SenderTableViewCell ?? SenderTableViewCell()
            cell.setData(message: message)
            
            return cell
        } else {
            let cell = self.messagesTableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as? ReceiverTableViewCell ?? ReceiverTableViewCell()
            cell.setData(message: message)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
