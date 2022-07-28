//
//  PostTableViewCell.swift
//  social_network_app
//
//  Created by admin on 7/14/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var projectUrlLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerPictureView: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikeImageView: UIImageView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var dislikesLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    
    lazy var viewModel = {
        PostsViewModel.shared
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(post: Post) {
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerPictureView.layer.borderWidth = 1
        containerPictureView.layer.borderColor = UIColor.black.cgColor
        
        
        titleLabel.text = post.title
        projectUrlLabel.text = post.projectUrl
        descriptionLabel.text = post.description
        likesLabel.text = String(format: "%.0f", post.likes)
        dislikesLabel.text = String(format: "%.0f", post.dislikes)
        loadPostImage(post: post)
        
        guard let user = UserProfileViewModel.shared.user else { return }
        verifyReaction(postId: post.id, userId: user.id)
    }
    
    func loadPostImage(post: Post) {
        PostsViewModel.shared.loadPostImage(post: post) { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.pictureImageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func verifyReaction(postId: String, userId: String) {
        viewModel.verfiyPostReactin(postId: postId, userId: userId) { result in
            switch result {
            case .success(let reactions):
                if !reactions.isEmpty {
                    guard let reacction = reactions.first else { return }
                    if reacction.reaction == 1 {
                        self.likeImageView.image = UIImage(named: "likeIconSelected")
                    } else {
                        self.dislikeImageView.image = UIImage(named: "dislikeIconSelected")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func likePost(_ sender: Any) {
        likeImageView.image = UIImage(named: "likeIconSelected")
        let buttonTag = likeButton.tag
        let post = viewModel.posts[buttonTag]
        viewModel.addPostReaction(post: post, typeReaction: TypeReactions.like)
    }
    
    @IBAction func disLikePost(_ sender: Any) {
        dislikeImageView.image = UIImage(named: "dislikeIconSelected")
        let buttonTag = dislikeButton.tag
        let post = viewModel.posts[buttonTag]
        viewModel.addPostReaction(post: post, typeReaction: TypeReactions.dislike)
    }
}
