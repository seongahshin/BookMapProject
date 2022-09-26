//
//  SceneDelegate.swift
//  BookMapProject
//
//  Created by 신승아 on 2022/09/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let firstVC = UINavigationController(rootViewController: ViewController())
//        let secondVC = UINavigationController(rootViewController: CalendarViewController())
        let secondVC = CalendarViewController()
        let thirdVC = UINavigationController(rootViewController: BookViewController())
        let fourthVC = UINavigationController(rootViewController: SettingViewController())
        
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([firstVC, secondVC, thirdVC, fourthVC], animated: true)
        tabBarController.tabBar.tintColor = Color.pointColor
        
        if let items = tabBarController.tabBar.items {
            items[0].image = UIImage(systemName: "map")
            items[0].title = "지도"
            
            items[1].image = UIImage(systemName: "calendar.badge.plus")
            items[1].title = "캘린더"
            
            items[2].image = UIImage(systemName: "photo.fill.on.rectangle.fill")
            items[2].title = "포토"
            
            items[3].image = UIImage(systemName: "gear.circle")
            items[3].title = "설정"
            
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
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
    }


}

