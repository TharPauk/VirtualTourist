//
//  SceneDelegate.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 18/05/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let dataController = DataController(modelName: "VirtualTourist")
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        dataController.load {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateViewController(identifier: "TravelLocationsMapView") as! TravelLocationsMapViewController
            rootVC.dataController = self.dataController
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = UINavigationController(rootViewController: rootVC)
            
            guard let windowScene = (scene as? UIWindowScene) else { return }
            self.window?.windowScene = windowScene
            
        }
       
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        dataController.saveContext()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        dataController.saveContext()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        dataController.saveContext()
    }


}

