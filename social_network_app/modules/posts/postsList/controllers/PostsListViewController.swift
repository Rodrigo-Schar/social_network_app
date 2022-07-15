//
//  PostsListViewController.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import UIKit

class PostsListViewController: UIViewController {
    
    @IBOutlet weak var postsSearchView: UISearchBar!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var addPostsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        setupImageButton()
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
    }
    
    func getPosts() {
        PostsViewModel.shared.loadPosts()
        PostsViewModel.shared.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.postsTableView.reloadData()
            }
        }
    }
    
    func setupTableview() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        let uiNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postsTableView.register(uiNib, forCellReuseIdentifier: "PostCell")
    }
    
    func setupImageButton() {
        addPostsButton.layer.cornerRadius = addPostsButton.bounds.size.width * 0.5
    }

    @IBAction func addPosts(_ sender: Any) {
        let vc = NewPostViewController()
        show(vc, sender: nil)
    }
    
}

extension PostsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 300
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostsViewModel.shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell ?? PostTableViewCell()
        
        let post = PostsViewModel.shared.posts[indexPath.row]
        cell.setData(post: post)
        
        return cell
    }
    
    
}
