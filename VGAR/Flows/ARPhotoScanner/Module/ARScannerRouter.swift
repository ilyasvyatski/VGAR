//
//  ARPhotoScannerRouter.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import UIKit

class ARScannerRouter: ARScannerRouting {
    weak var view: UIViewController?
    private var coordinator: GeneralCoordinator?
    
    init(coordinator: GeneralCoordinator?) {
        self.coordinator = coordinator
    }
    
    func createModule() -> UIViewController {
        let vc = ARScannerView()
        ModuleConfigurator().configure(
            vc: vc,
            presenter: ARScannerPresenter(),
            interactor: ARScannerInteractor(),
            router: self
        )
        return vc
    }
    
    func toInstruction() {
        //view?.navigationController?.popViewController(animated: true)
        coordinator?.toInstruction()
    }
}
