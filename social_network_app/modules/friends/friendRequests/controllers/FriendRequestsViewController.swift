//
//  FriendRequestsViewController.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import UIKit

class FriendRequestsViewController: UIViewController {
    
    @IBOutlet weak var friendRequestsTableView: UITableView!
    
    lazy var viewModel = {
        FriendRequestsViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getFriendRequests()
    }
    
    func setupView() {
        self.friendRequestsTableView.delegate = self
        self.friendRequestsTableView.dataSource = self
        
        let uiNib = UINib(nibName: "FriendRequestTableViewCell", bundle: nil)
        self.friendRequestsTableView.register(uiNib, forCellReuseIdentifier: "FriendRequestCell")
    }
    
    func getFriendRequests() {
        viewModel.loadFriendsRequests() {
            self.friendRequestsTableView.reloadData()
        }
    }
}

extension FriendRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friendRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendRequestsTableView.dequeueReusableCell(withIdentifier: "FriendRequestCell") as? FriendRequestTableViewCell ?? FriendRequestTableViewCell()
        let request = viewModel.friendRequests[indexPath.row]
        
        viewModel.getUserRequest(userId: request.userSenderId) {
            if let user = self.viewModel.users.first {
                cell.setData(user: user)
            }
        }
        
        cell.confirmButton.addTarget(self, action: #selector(confirmFriendRequest(sender:)), for: .touchUpInside)
        cell.confirmButton.tag = indexPath.row
        cell.declineButton.addTarget(self, action: #selector(declineFriendRequest(sender:)), for: .touchUpInside)
        cell.declineButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func confirmFriendRequest(sender: UIButton) {
        let buttonTag = sender.tag
        let request = viewModel.friendRequests[buttonTag]
        viewModel.confirmFriendRequest(friendRequest: request) {
            self.friendRequestsTableView.reloadData()
        }
    }
    
    @objc func declineFriendRequest(sender: UIButton) {
        let buttonTag = sender.tag
        let request = viewModel.friendRequests[buttonTag]
        viewModel.declineFriendRequest(friendRequest: request) {
            self.friendRequestsTableView.reloadData()
        }
    }
    
    
}
