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
    private weak var timer: Timer?
    private var currentDots = "."
    
    func onStart() {
        router?.toMain()
    }
    
    deinit { print("§ \(self) deinited") }
}
