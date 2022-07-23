//
//  FriendsListViewController.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import UIKit

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    @IBOutlet weak var friendsTableView: UITableView!
    
    lazy var viewModel = {
        FriendsListViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getFriends()
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
        }
    }
}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendTableViewCell ?? FriendTableViewCell()
        let request = viewModel.friends[indexPath.row]
        
        viewModel.getUserFriend(userId: request.userSenderId) {
            if let user = self.viewModel.users.first {
                cell.setData(user: user)
            }
        }
        
        cell.chatButton.addTarget(self, action: #selector(messageFriend(sender:)), for: .touchUpInside)
        cell.chatButton.tag = indexPath.row
        cell.chatButton.addTarget(self, action: #selector(deleteFriend(sender:)), for: .touchUpInside)
        cell.chatButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func messageFriend(sender: UIButton) {
        let buttonTag = sender.tag
        let request = viewModel.friends[buttonTag]
        
    }
    
    @objc func deleteFriend(sender: UIButton) {
        let buttonTag = sender.tag
        let request = viewModel.friends[buttonTag]
        
    }
}

extension FriendsListViewController: UISearchBarDelegate {
    
}
