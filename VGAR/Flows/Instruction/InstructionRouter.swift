//
//  InstructionRouter.swift
//  VGAR
//
//  Created by Ilya Svyatski on 29.10.2025.
//

import UIKit

class InstructionRouter: InstructionRouting {
    weak var view: UIViewController?
    private weak var coordinator: RootCoordinator?
    
    init(coordinator: RootCoordinator?) {
        self.coordinator = coordinator
    }
    
    func createModule() -> UIViewController {
        let vc = InstructionView()
        ModuleConfigurator().configure(
            vc: vc,
            presenter: InstructionPresenter(),
            interactor: InstructionInteractor(),
            router: self
        )
        return vc
    }
    
    func toARScanner() {
        coordinator?.toNextScene(route: .general)
    }
    
    func toLink(_ link: String) {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    deinit { print("§ \(self) deinited") }
}
