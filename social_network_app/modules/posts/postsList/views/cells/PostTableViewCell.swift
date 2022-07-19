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
        loadPostImage(post: post)
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
    
}
