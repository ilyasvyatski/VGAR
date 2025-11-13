//
//  SplashPresenter.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import Foundation

class SplashPresenter: SplashPreparing {
    weak var view: (any SplashPresenting)?
    var router: (any SplashRouting)?
    
    func onStart() {
        router?.toMain()
    }
    
    deinit { print("§ \(self) deinited") }
}
