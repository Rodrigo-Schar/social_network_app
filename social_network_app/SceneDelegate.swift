//
//  SceneDelegate.swift
//  social_network_app
//
//  Created by admin on 6/29/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static weak var shared: SceneDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        setupRootControllerIfNeeded(validUser: false)
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func setupRootControllerIfNeeded(validUser: Bool) {
        let login = LoginViewController()
        let validUser = login.verifyValidUser()
        if validUser {
            // Create VC for TabBar
            let rootViewController = getRootViewControllerForValidUser()
            UserProfileViewModel.shared.getDataUser()
            self.window?.rootViewController = rootViewController
        } else {
            let rootViewController = getRootViewControllerForInvalidUser()
            self.window?.rootViewController = rootViewController
        }
        self.window?.makeKeyAndVisible()
    }
    
    func getRootViewControllerForInvalidUser() -> UIViewController {
        createNavController(for: LoginViewController(), title: "Sing In", image: UIImage(systemName: "newspaper.fill")!)
    }
        
    func getRootViewControllerForValidUser() -> UIViewController {
        // Create TabBarVC
        let tabBarVC = UITabBarController()
        tabBarVC.view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBarVC.tabBar.tintColor = UIColor(named: "black-color")
            
        // Add VCs to TabBarVC
        tabBarVC.viewControllers = [
            createNavController(for: PostsListViewController(), title: "Home", image: UIImage(named: "homeIconSelected")!),
                
            createNavController(for: UserProfileViewController(), title: "Chats", image: UIImage(named: "chatsIcon")!),
                
            createNavController(for: PostsListViewController(), title: "Friends", image: UIImage(named: "friendsIcon")!),
                
            createNavController(for: UserProfileViewController(), title: "Profile", image: UIImage(named: "profileIcon")!)
        ]
            
        return tabBarVC
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                             title: String,
                                             image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        //navController.navigationBar.prefersLargeTitles = true
        //navController.navigationBar.backgroundColor = UIColor(named: "primary")
        navController.navigationBar.tintColor = .white
            
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "primary")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
            
        navController.modalPresentationStyle = .overFullScreen
            
            
        rootViewController.navigationItem.title = title
            
            
        return navController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        CoreDataManager.shared.saveContext()
    }


}

