//
//  RootCoordinator.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import UIKit

class RootCoordinator {
    enum EntranceRoute {
        case splash, instruction, general
    }
    
    private weak var window: UIWindow?
    private var activeRoute: EntranceRoute
    private weak var generalCoordinator: GeneralCoordinator?
    
    init(window: UIWindow) {
        self.activeRoute = .splash
        self.window = window
    }
    
    func start() {
        toNextScene(route: .splash)
        window?.makeKeyAndVisible()
    }
    
    func toNextScene(route: EntranceRoute) {
        activeRoute = route
        switch route {
        case .splash:
            animatedTransitTo(vc: SplashRouter(coordinator: self).createModule())
        case .instruction:
            animatedTransitTo(vc: InstructionRouter(coordinator: self).createModule())
        case .general:
            let generalCoordinator = GeneralCoordinator(coordinator: self)
            self.generalCoordinator = generalCoordinator
            animatedTransitTo(vc: generalCoordinator.createRoot())
        }
    }
    
    ///Cross disolve animated transition between modules
    private func animatedTransitTo(vc: UIViewController) {
        guard let window = window else { return }
        print("§ transit to \(vc.self)")

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
            window.rootViewController = vc
        })
    }
}
