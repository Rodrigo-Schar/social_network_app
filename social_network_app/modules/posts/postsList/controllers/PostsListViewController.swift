//
//  PostsListViewController.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import UIKit

class PostsListViewController: UIViewController {
    
    @IBOutlet weak var postsSearchBar: UISearchBar!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var addPostsButton: UIButton!
    
    lazy var viewModel = {
        PostsViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImageButton()
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.postsTableView.reloadData()
    }
    
    func getPosts() {
        viewModel.loadPosts() {
            self.postsTableView.reloadData()
        }
        //viewModel.reloadData = { [weak self] in
        //    DispatchQueue.main.async {
        //        self?.postsTableView.reloadData()
        //    }
        //}
    }
    
    func setupView() {
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        self.postsSearchBar.delegate = self
        
        let uiNib = UINib(nibName: ConstantVariables.postCellNib, bundle: nil)
        self.postsTableView.register(uiNib, forCellReuseIdentifier: ConstantVariables.postCellIdentifier)
    }
    
    func setupImageButton() {
        addPostsButton.layer.cornerRadius = addPostsButton.bounds.size.width * 0.5
    }

    @IBAction func addPosts(_ sender: Any) {
        let vc = NewPostViewController()
        vc.typeView = 1
        vc.delegate = self
        show(vc, sender: nil)
    }
    
}

extension PostsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: ConstantVariables.postCellIdentifier) as? PostTableViewCell ?? PostTableViewCell()
        
        let post = viewModel.posts[indexPath.row]
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
        let post = viewModel.posts[indexPath.row]
        viewModel.addPostForDetail(post: post)
        
        let vc = PostDetailViewController()
        show(vc, sender: nil)
    }
    
    @objc func likePost(sender: UIButton) {
        let buttonTag = sender.tag
        let post = viewModel.posts[buttonTag]
        viewModel.addPostReaction(post: post, typeReaction: TypeReactions.like)
    }
    
    @objc func dislikePost(sender: UIButton) {
        let buttonTag = sender.tag
        let post = viewModel.posts[buttonTag]
        viewModel.addPostReaction(post: post, typeReaction: TypeReactions.dislike)
    }
    
    @objc func commentPost(sender: UIButton) {
        let buttonTag = sender.tag
        let post = viewModel.posts[buttonTag]
        viewModel.addPostForDetail(post: post)
        
        let vc = PostDetailViewController()
        show(vc, sender: nil)
    }
    
}

extension PostsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        
        if text.isEmpty {
            viewModel.posts = viewModel.postsOriginalList
            self.postsTableView.reloadData()
        } else {
            viewModel.searchPost(text: text)
            self.postsTableView.reloadData()
        }
        
    }
}

extension PostsListViewController: NewEditPostDelegate {
    func postAdded(post: Post) {
        self.postsTableView.reloadData()
    }
    
    func postEdited(post: Post) {
        if let index = viewModel.posts.firstIndex(where: { post.id == $0.id }) {
            let indexPath = IndexPath(row: index, section: 0)
            self.postsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}
