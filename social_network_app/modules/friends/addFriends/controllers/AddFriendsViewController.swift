//
//  AddFriendsViewController.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import UIKit
import SVProgressHUD

class AddFriendsViewController: UIViewController {
    
    @IBOutlet weak var addFriendSearchBar: UISearchBar!
    @IBOutlet weak var addFriendTableView: UITableView!
    
    lazy var viewModel = {
        AddFriendsViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.delegate = self
    }
    
    func setupView() {
        addFriendTableView.delegate = self
        addFriendTableView.dataSource = self
        addFriendSearchBar.delegate = self
        
        let uiNib = UINib(nibName: "AddFriendTableViewCell", bundle: nil)
        self.addFriendTableView.register(uiNib, forCellReuseIdentifier: "AddFriendCell")
    }
}

extension AddFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addFriendTableView.dequeueReusableCell(withIdentifier: "AddFriendCell") as? AddFriendTableViewCell ?? AddFriendTableViewCell()
        
        let user = viewModel.usersList[indexPath.row]
        cell.setupData(user: user)
        cell.sendRequestButton.addTarget(self, action: #selector(sendRequest(sender:)), for: .touchUpInside)
        cell.sendRequestButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func sendRequest(sender: UIButton) {
        SVProgressHUD.show()
        let buttonTag = sender.tag
        let user = viewModel.usersList[buttonTag]
        if let userData = UserProfileViewModel.shared.user {
            viewModel.sendfriendRequest(userSenderId: userData.id, userReceiverId: user.id)
        }
    }
    
    
}

extension AddFriendsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        SVProgressHUD.show()
        viewModel.searchFriend(text: text) {
            self.addFriendTableView.reloadData()
            self.view.endEditing(true)
            SVProgressHUD.dismiss()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.addFriendSearchBar.text = ""
        viewModel.usersList.removeAll()
        self.addFriendTableView.reloadData()
        self.view.endEditing(true)
    }
}

extension AddFriendsViewController: addFriendsViewModelDelegate {
    func friendAdded(code: Int) {
        if code == 1 {
            SVProgressHUD.dismiss()
            self.addFriendSearchBar.text = ""
            viewModel.usersList.removeAll()
            self.addFriendTableView.reloadData()
            self.showToastError(message: "Can not Send request to yourself", seconds: 2)
        }
        self.addFriendSearchBar.text = ""
        self.addFriendTableView.reloadData()
        SVProgressHUD.dismiss()
        self.showToast(message: "Request Sent", seconds: 1)
    }
    
    
}
