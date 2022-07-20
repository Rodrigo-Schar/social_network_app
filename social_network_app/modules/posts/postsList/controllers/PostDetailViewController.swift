//
//  PostDetailViewController.swift
//  social_network_app
//
//  Created by admin on 7/18/22.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var urlProjectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postCommentButton: SecondaryButton!
    
    
    lazy var viewModel = {
        PostsViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadDetailData()
        loadComments()
    }
    
    func setUpView() {
        self.commentsTableView.delegate = self
        self.commentsTableView.dataSource = self
        self.commentTextField.layer.cornerRadius = 10
        //self.commentsTableView.rowHeight = UITableView.automaticDimension
        
        let uiNib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        self.commentsTableView.register(uiNib, forCellReuseIdentifier: "CommentCell")
    }
    
    func loadDetailData() {
        if let post = viewModel.postDetail.first {
            self.titleLabel.text = post.title
            self.urlProjectLabel.text = post.projectUrl
            self.descriptionLabel.text = post.description
            loadPostDetailImage(post: post)
        }
    }
    
    func loadComments() {
        if let post = viewModel.postDetail.first {
            viewModel.loadComments(postId: post.id)
            viewModel.reloadData = { [weak self] in
                DispatchQueue.main.async {
                    self?.commentsTableView.reloadData()
                }
            }
        }
    }
    
    func loadPostDetailImage(post: Post) {
        viewModel.loadPostImage(post: post) { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.postImageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @IBAction func postComment(_ sender: Any) {
        guard let post = viewModel.postDetail.first else { return }
        guard let userData = UserProfileViewModel.shared.user else { return }
        guard let text = commentTextField.text else { return }
        
        viewModel.addNewComment(postId: post.id, ownerId: userData.id, description: text) { result in
            switch result {
            case .success(let comment):
                self.commentTextField.text = ""
                self.commentsTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    

}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentTableViewCell ?? CommentTableViewCell()
        
        let comment = viewModel.comments[indexPath.row]
        if let userData = UserProfileViewModel.shared.user {
            cell.setData(user: userData.name, comment: comment)
        }
        
        return cell
        
    }
    
    
}
