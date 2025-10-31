//
//  SplashRouter.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import UIKit

class SplashRouter: SplashRouting {
    weak var view: UIViewController?
    private weak var coordinator: RootCoordinator?
    
    init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
    }
    
    func createModule() -> UIViewController {
        let vc = SplashView()
        ModuleConfigurator().configure(
            vc: vc,
            presenter: SplashPresenter(),
            interactor: SplashInteractor(),
            router: self
        )
        return vc
    }
        
    func toMain() {
        coordinator?.toNextScene(
            route: CacheManager.shared.instructionPresented ? .general : .instruction
        )
    }
    
    deinit { print("§ \(self) deinited") }
}
