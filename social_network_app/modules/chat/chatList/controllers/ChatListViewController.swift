//
//  ChatListViewController.swift
//  social_network_app
//
//  Created by admin on 7/23/22.
//

import UIKit

class ChatListViewController: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    
    lazy var viewModel = {
        ChatListViewModel.shared
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadChats()
    }
    
    func setupView() {
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        
        let uiNib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        self.chatTableView.register(uiNib, forCellReuseIdentifier: "ChatCell")
    }
    
    func loadChats() {
        guard let userData = UserProfileViewModel.shared.user else { return }
        viewModel.getChatIdBySender(senderId: userData.id) {
            self.chatTableView.reloadData()
        }
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell") as? ChatTableViewCell ?? ChatTableViewCell()
        let chat = viewModel.chats[indexPath.row]
        
        if let userData = UserProfileViewModel.shared.user, userData.id == chat.participant1Id {
            viewModel.getUserChat(userId: chat.participant2Id) {
                if let user = self.viewModel.users.first {
                    cell.setData(user: user)
                }
            }
        } else {
            viewModel.getUserChat(userId: chat.participant1Id) {
                if let user = self.viewModel.users.first {
                    cell.setData(user: user)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = viewModel.chats[indexPath.row]
        
        if let userData = UserProfileViewModel.shared.user, userData.id == chat.participant1Id {
            viewModel.getUserChat(userId: chat.participant2Id) {
                if let user = self.viewModel.users.first {
                    SendMessageViewModel.shared.userReceiver = user
                    let vc = SendMessageViewController()
                    self.show(vc, sender: nil)
                }
            }
        } else {
            viewModel.getUserChat(userId: chat.participant1Id) {
                if let user = self.viewModel.users.first {
                    SendMessageViewModel.shared.userReceiver = user
                    let vc = SendMessageViewController()
                    self.show(vc, sender: nil)
                }
            }
        }
        
        
    }
}
