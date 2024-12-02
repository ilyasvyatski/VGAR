//
//  SceneDelegate.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Создаем LaunchScreenViewController из LaunchScreen.storyboard и добавляем его как корневой контроллер
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        if let launchScreenVC = launchScreenStoryboard.instantiateInitialViewController() {
            window.rootViewController = launchScreenVC
            window.makeKeyAndVisible()
            
            // Задержка в 2 секунды перед переходом на WelcomeGuideViewController
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let welcomeGuideVC = WelcomeGuideViewController()
                window.rootViewController = welcomeGuideVC
            }
        }
    }
}
