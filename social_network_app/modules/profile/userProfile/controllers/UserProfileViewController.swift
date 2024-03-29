//
//  UserProfileViewController.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import UIKit
import FirebaseStorage
import SwiftUI
import SVProgressHUD

class UserProfileViewController: ImagePickerHelperViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addProfileImageButton: UIButton!
    @IBOutlet weak var myPostsTableView: UITableView!
    @IBOutlet weak var pictureContainerView: UIView!
    
    lazy var viewModel = {
        UserProfileViewModel.shared
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        setupView()
        loadDataUser()
        loadProfilePicture()
    }
    
    func setupView() {
        pictureContainerView.layer.cornerRadius = 20
        pictureContainerView.layer.borderWidth = 1
        pictureContainerView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = 20
        addProfileImageButton.layer.cornerRadius = addProfileImageButton.bounds.size.width * 0.5
        
        self.myPostsTableView.delegate = self
        self.myPostsTableView.dataSource = self
        
        let uiNib = UINib(nibName: ConstantVariables.postCellNib, bundle: nil)
        self.myPostsTableView.register(uiNib, forCellReuseIdentifier: ConstantVariables.postCellIdentifier)
    }
    
    func loadDataUser() {
        
        if let userData = viewModel.user {
            nameLabel.text = userData.name
            nicknameLabel.text = userData.nickname
            emailLabel.text = userData.email
            viewModel.loadMyPosts(ownerId: userData.id) {
                self.myPostsTableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func loadProfilePicture() {
        if let user = viewModel.user, !user.imageUrl.isEmpty {
            viewModel.loadProfilePicture(user: user) { result in
                switch result {
                    case .success(let data):
                        self.profileImageView.image = UIImage(data: data)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }

    @IBAction func addProfileImage(_ sender: Any) {
        showAddImageOptionAlert()
    }
    
    override func saveSelectedImageInFirebase(withExtension: String, data: Data) {
        SVProgressHUD.show()
        if let user = viewModel.user {
            viewModel.addProfilePicture(data: data, user: user) {
                SVProgressHUD.dismiss()
                self.showToast(message: "Photo Updated", seconds: 1)
                self.loadProfilePicture()
            }
            
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            guard let email = self.emailLabel.text else { return }
            self.viewModel.setLogOut(email: email)
            self.setupLogOut()
            let sceneDelegate = SceneDelegate.shared
            sceneDelegate?.setupRootControllerIfNeeded(validUser: false)
        })
                
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Canceled")
        }
                
        dialogMessage.addAction(confirm)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func setupLogOut() {
        viewModel.user = nil
        viewModel.myPosts.removeAll()
        viewModel.userLogin = nil
        viewModel.postDetail.removeAll()
        
        PostDetailViewModel.shared.postDetail.removeAll()
        PostDetailViewModel.shared.comments.removeAll()
        PostsViewModel.shared.posts.removeAll()
        PostsViewModel.shared.postsOriginalList.removeAll()
        
        ChatListViewModel.shared.chats.removeAll()
        ChatListViewModel.shared.users.removeAll()
        
        SendMessageViewModel.shared.chats.removeAll()
        SendMessageViewModel.shared.messages.removeAll()
        SendMessageViewModel.shared.userReceiver = nil
        
        FriendsListViewModel.shared.users.removeAll()
        FriendsListViewModel.shared.friends.removeAll()
        AddFriendsViewModel.shared.usersList.removeAll()
        FriendRequestsViewModel.shared.users.removeAll()
        FriendRequestsViewModel.shared.friendRequests.removeAll()
        
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPostsTableView.dequeueReusableCell(withIdentifier: ConstantVariables.postCellIdentifier) as? PostTableViewCell ?? PostTableViewCell()
        cell.selectionStyle = .none
        
        let post = viewModel.myPosts[indexPath.row]
        cell.setData(post: post)
        
        cell.likeButton.addTarget(self, action: #selector(likePost(sender:)), for: .touchUpInside)
        cell.likeButton.tag = indexPath.row
        cell.dislikeButton.addTarget(self, action: #selector(dislikePost(sender:)), for: .touchUpInside)
        cell.dislikeButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: #selector(commentPost(sender:)), for: .touchUpInside)
        cell.commentButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.myPosts[indexPath.row]
        viewModel.addPostForDetail(post: post)
        
        let vc = NewPostViewController()
        vc.typeView = 2
        show(vc, sender: nil)
    }
    
    @objc func likePost(sender: UIButton) {
        let buttonTag = sender.tag
        let post = viewModel.myPosts[buttonTag]
        PostsViewModel.shared.addPostReaction(post: post, typeReaction: TypeReactions.like)
    }
    
    @objc func dislikePost(sender: UIButton) {
        let buttonTag = sender.tag
        let post = viewModel.myPosts[buttonTag]
        PostsViewModel.shared.addPostReaction(post: post, typeReaction: TypeReactions.dislike)
    }
    
    @objc func commentPost(sender: UIButton) {
        let buttonTag = sender.tag
        let post = viewModel.myPosts[buttonTag]
        PostDetailViewModel.shared.addPostForDetail(post: post)
        
        let vc = PostDetailViewController()
        show(vc, sender: nil)
    }
}
