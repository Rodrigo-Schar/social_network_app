//
//  NewPostViewController.swift
//  social_network_app
//
//  Created by admin on 7/14/22.
//

import UIKit

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var postImageImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
    }
    
    @IBAction func addPost(_ sender: Any) {
        guard let title = titleTextField.text, let descrip = descriptionTextField.text, let projectUrl = urlTextField.text  else { return }
        guard let userData = UserProfileViewModel.shared.users.first else { return }
        
        PostsViewModel.shared.addNewPost(title: title, description: descrip, projecUrl: projectUrl, imageUrl: "", ownerId: userData.id) { result in
            switch result {
                case .success(let post):
                    print(post)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}
