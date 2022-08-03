//
//  FriendsListViewController.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import UIKit
import SVProgressHUD

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    @IBOutlet weak var friendsTableView: UITableView!
    
    lazy var viewModel = {
        FriendsListViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        setupView()
        getFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        getFriends()
        print(self.viewModel.friends.count)
    }
    
    func setupView() {
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self
        self.friendsSearchBar.delegate = self
        
        let uiNib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        self.friendsTableView.register(uiNib, forCellReuseIdentifier: "FriendCell")
    }
    
    func getFriends() {
        viewModel.loadFriends() {
            self.friendsTableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendTableViewCell ?? FriendTableViewCell()
        cell.selectionStyle = .none
        let request = viewModel.friends[indexPath.row]
        
        if let userData = UserProfileViewModel.shared.user, userData.id == request.userReceiverId {
            viewModel.getUserFriend(userId: request.userSenderId) {
                if let user = self.viewModel.users.first {
                    cell.setData(user: user)
                }
            }
        } else {
            viewModel.getUserFriend(userId: request.userReceiverId) {
                if let user = self.viewModel.users.first {
                    cell.setData(user: user)
                }
            }
        }
        
        cell.chatButton.addTarget(self, action: #selector(messageFriend(sender:)), for: .touchUpInside)
        cell.chatButton.tag = indexPath.row
        cell.deleteFriendButton.addTarget(self, action: #selector(deleteFriend(sender:)), for: .touchUpInside)
        cell.deleteFriendButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func messageFriend(sender: UIButton) {
        let buttonTag = sender.tag
        let request = viewModel.friends[buttonTag]
        
        if let userData = UserProfileViewModel.shared.user, userData.id == request.userReceiverId {
            viewModel.getUserFriend(userId: request.userSenderId) {
                if let user = self.viewModel.users.first {
                    SendMessageViewModel.shared.userReceiver = user
                    let vc = SendMessageViewController()
                    self.show(vc, sender: nil)
                }
            }
        } else {
            viewModel.getUserFriend(userId: request.userReceiverId) {
                if let user = self.viewModel.users.first {
                    SendMessageViewModel.shared.userReceiver = user
                    let vc = SendMessageViewController()
                    self.show(vc, sender: nil)
                }
            }
        }
        
    }
    
    @objc func deleteFriend(sender: UIButton) {
        let buttonTag = sender.tag
        let request = viewModel.friends[buttonTag]
        
        let dialogMessage = UIAlertController(title: "Delete Friend", message: "Are you sure you want to delete your friend?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "delete", style: .destructive, handler: { (action) -> Void in
            self.viewModel.deleteFriendBySenderId(userSenderId: request.userSenderId, userId: request.userReceiverId)
        })
                
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Canceled")
        }
                
        dialogMessage.addAction(confirm)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
        
        
    }
}

extension FriendsListViewController: UISearchBarDelegate {
    
}
