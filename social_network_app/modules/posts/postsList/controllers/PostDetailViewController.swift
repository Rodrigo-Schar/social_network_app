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
    
    lazy var viewModel = {
        PostsViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailData()
    }
    
    func loadDetailData() {
        if let post = viewModel.postDetail.first {
            self.titleLabel.text = post.title
            self.urlProjectLabel.text = post.projectUrl
            self.descriptionLabel.text = post.description
            loadPostDetailImage(post: post)
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

}
