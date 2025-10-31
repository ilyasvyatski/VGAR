//
//  GeneralCoordinator.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import Foundation
import UIKit

class GeneralCoordinator {
    private weak var coordinator: RootCoordinator?
    private weak var navigationController: BaseNavigationController?
    
    init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit { print("§ \(self) deinited") }
    
    func createRoot() -> BaseNavigationController {
        let navController = BaseNavigationController(
            rootViewController: ARScannerRouter(coordinator: self).createModule()
        )
        self.navigationController = navController
        return navController
    }

    ///Push by tabbar's navigation
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///Present bottom sheet by tabbar's navigation
    func presentCBS(vc: UIViewController) {
        //vc.transitioningDelegate = cbsTransitioningDelegate
        vc.modalPresentationStyle = .custom
        navigationController?.present(vc, animated: true)
    }
    
    ///Pop current module by tabbar's navigation
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    ///Dismiss current module by tabbar's navigation
    func dismiss() {
        navigationController?.topViewController?.dismiss(animated: true)
    }
    
    func toInstruction() {
        coordinator?.toNextScene(route: .instruction)
    }
    
    ///Set loading view at root module
    func setLoading(_ isLoading: Bool) {
        navigationController?.setLoading(isLoading)
    }
    
    func presentVC(_ vc: UIViewController) {
        navigationController?.present(vc, animated: true)
    }
}
