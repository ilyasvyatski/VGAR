//
//  SceneDelegate.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: RootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let newWindow = UIWindow(windowScene: windowScene)
        window = newWindow
        
        //Set ignoring dark theme
        newWindow.overrideUserInterfaceStyle = .light
        
        //Set global appearance configuration
        //GlobalAppearanceConfigurator().setAppearance()
        
        //Set root coordinator and start session
        coordinator = RootCoordinator(window: newWindow)
        coordinator?.start()
       
        //window?.makeKeyAndVisible()
    }
}
