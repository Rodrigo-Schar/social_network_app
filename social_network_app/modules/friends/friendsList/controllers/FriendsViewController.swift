//
//  FriendsViewController.swift
//  social_network_app
//
//  Created by admin on 7/21/22.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    private lazy var friendsListVC: FriendsListViewController = {
        let vc = FriendsListViewController()
        return vc
    }()
    
    private lazy var addFriendVC: AddFriendsViewController = {
        let vc = AddFriendsViewController()
        return vc
    }()
    
    private lazy var friendRequestsVC: FriendRequestsViewController = {
        let vc = FriendRequestsViewController()
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        segmentedOptionChanged(nil)
    }
    
    func setupSegmentedControl() {
        friendsSegmentedControl.removeAllSegments()
        
        friendsSegmentedControl.insertSegment(withTitle: "Friends", at: 0, animated: true)
        friendsSegmentedControl.insertSegment(withTitle: "Add Friend", at: 1, animated: true)
        friendsSegmentedControl.insertSegment(withTitle: "Friend Request", at: 2, animated: true)
        
        friendsSegmentedControl.selectedSegmentIndex = 0
        
        friendsSegmentedControl.addTarget(self, action: #selector(segmentedOptionChanged), for: .valueChanged)
    }
    
    // Settup Secgmente control
    private func addViewController(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    @objc func segmentedOptionChanged(_ sender: UISegmentedControl?) {
        
        switch friendsSegmentedControl.selectedSegmentIndex {
            
        case 0:
            remove(asChildViewController: addFriendVC)
            remove(asChildViewController: friendRequestsVC)
            addViewController(asChildViewController: friendsListVC)
        case 1:
            remove(asChildViewController: friendsListVC)
            remove(asChildViewController: friendRequestsVC)
            addViewController(asChildViewController: addFriendVC)
        default:
            remove(asChildViewController: friendsListVC)
            remove(asChildViewController: addFriendVC)
            addViewController(asChildViewController: friendRequestsVC)
            
        }
        
    }

}
