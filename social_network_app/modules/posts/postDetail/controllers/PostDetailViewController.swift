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
    @IBOutlet weak var messageBoxView: NSLayoutConstraint!
    
    lazy var viewModel = {
        PostDetailViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpKeyboardNotification()
        setUpLabelUrlTap()
        loadDetailData()
        loadComments()
    }
    
    func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func setUpLabelUrlTap() {
        urlProjectLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapFunction))
        tap.numberOfTapsRequired = 1
        urlProjectLabel.addGestureRecognizer(tap)
    }
    
    func setUpView() {
        self.commentsTableView.delegate = self
        self.commentsTableView.dataSource = self
        self.commentTextField.layer.cornerRadius = 10
        self.navigationItem.title = "Post Detail"
        
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
            viewModel.loadComments(postId: post.id) {
                self.commentsTableView.reloadData()
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
        guard let text = commentTextField.text, !text.isEmpty else { return }
        
        viewModel.addNewComment(postId: post.id, ownerId: userData.id, description: text) { result in
            switch result {
            case .success(_):
                self.commentTextField.text = ""
                self.commentsTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func keyBoardWillShow(_ notificacion: Notification){
        guard let userInfo = notificacion.userInfo,
              let keyboardframe = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        messageBoxView.constant = (keyboardframe.size.height - 80) * -1
        UIView.animate(withDuration: duration){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyBoardWillHide(_ notificacion: Notification){
        guard let userInfo = notificacion.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        messageBoxView.constant = 0
        UIView.animate(withDuration: duration){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer)
    {
        // this is for copying label text to clipboard.
        let labeltext = urlProjectLabel.text
        UIPasteboard.general.string = labeltext

    }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentTableViewCell ?? CommentTableViewCell()
        cell.selectionStyle = .none
        
        let comment = viewModel.comments[indexPath.row]
        if let userData = UserProfileViewModel.shared.user {
            cell.setData(user: userData.name, comment: comment)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
