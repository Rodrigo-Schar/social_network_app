//
//  NewPostViewController.swift
//  social_network_app
//
//  Created by admin on 7/14/22.
//

import UIKit

class NewPostViewController: ImagePickerHelperViewController {
    
    @IBOutlet weak var addEditLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var postImageImageView: UIImageView!
    @IBOutlet weak var newEditPostButton: PrimaryButton!
    
    lazy var viewModel = {
        NewEditPostViewModel.shared
    }()
    var typeView: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if typeView == 1 {
            setupNewPostView()
        } else {
            setupEditPostView()
        }
    }
    
    func setupNewPostView() {
        self.navigationItem.title = "New Post"
        titleTextField.text = ""
        descriptionTextField.text = ""
        urlTextField.text = ""
        postImageImageView.image = nil
        addEditLabel.text = "New Post"
        newEditPostButton.setTitle("Post", for: .normal)
    }
    
    func setupEditPostView() {
        if let postData = UserProfileViewModel.shared.postDetail.first {
            let trashImage = UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysOriginal)
            let trashButton = UIBarButtonItem(image: trashImage, style: .plain, target: self, action: #selector(trashPost))
            navigationItem.rightBarButtonItem = trashButton
            self.navigationItem.title = "Edit Post"
            
            addEditLabel.text = "Edit Post"
            newEditPostButton.setTitle("Edit Post", for: .normal)
            titleTextField.text = postData.title
            descriptionTextField.text = postData.description
            urlTextField.text = postData.projectUrl
            
            loadPostImage(post: postData)
        }
    }
    
    func loadPostImage(post: Post) {
        PostsViewModel.shared.loadPostImage(post: post) { result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.postImageImageView.image = UIImage(data: data)
                        self.viewModel.dataImage = data
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        showAddImageOptionAlert()
    }
    
    override func saveSelectedImageInFirebase(withExtension: String, data: Data) {
        self.postImageImageView.image = UIImage(data: data)
        viewModel.dataImage = data
    }
    
    @IBAction func addPost(_ sender: Any) {
        if typeView == 1 {
            addPost()
        } else {
            editPost()
        }
    }
    
    func addPost() {
        guard let title = titleTextField.text, let descrip = descriptionTextField.text, let projectUrl = urlTextField.text  else { return }
        guard let userData = UserProfileViewModel.shared.user else { return }
        
        viewModel.addNewPost(title: title, description: descrip, projecUrl: projectUrl, ownerId: userData.id) { result in
            switch result {
                case .success(let post):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func editPost() {
        guard let title = titleTextField.text, let descrip = descriptionTextField.text, let projectUrl = urlTextField.text  else { return }
        guard let userData = UserProfileViewModel.shared.user else { return }
        guard let post = UserProfileViewModel.shared.postDetail.first else { return }
        
        viewModel.editPost(postId: post.id, title: title, description: descrip, projecUrl: projectUrl, likes: post.likes, dislikes: post.dislikes, ownerId: userData.id, created: post.createdAt) { result in
            switch result {
                case .success(let post):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @objc func trashPost() {
        guard let postData = UserProfileViewModel.shared.postDetail.first else { return }
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete the Post?: \(postData.title)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler:  { action in
            
            self.viewModel.deletePost(postId: postData.id) {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)


    }
    
}
