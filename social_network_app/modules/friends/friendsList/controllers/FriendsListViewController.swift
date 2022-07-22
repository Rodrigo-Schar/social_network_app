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
        
        let uiNib = UINib(nibName: "FriendRequestTableViewCell", bundle: nil)
        self.friendsTableView.register(uiNib, forCellReuseIdentifier: "FriendRequestCell")
    }
    
    func getFriends() {
        viewModel.loadFriends()
    }
}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendRequestCell") as? FriendRequestTableViewCell ?? FriendRequestTableViewCell()
        let request = viewModel.friends[indexPath.row]
        
        viewModel.getUserFriend(userId: request.userSenderId) {
            if let user = self.viewModel.users.first {
                cell.setData(user: user)
            }
        }
        
        cell.confirmButton.addTarget(self, action: #selector(messageFriend(sender:)), for: .touchUpInside)
        cell.confirmButton.tag = indexPath.row
        cell.declineButton.addTarget(self, action: #selector(deleteFriend(sender:)), for: .touchUpInside)
        cell.declineButton.tag = indexPath.row
        
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
