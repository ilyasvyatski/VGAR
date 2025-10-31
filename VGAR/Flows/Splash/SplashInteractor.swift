//
//  SplashInteractor.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import Foundation

class SplashInteractor: SplashLogic {
    var presenter: (any SplashPreparing)?
    
    func onViewLoaded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.presenter?.onStart()
        }
    }
    
    deinit { print("§ \(self) deinited") }
}
