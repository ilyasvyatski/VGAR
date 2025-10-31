//
//  SplashProtocols.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

protocol SplashPresenting: ConfigurableView {}

protocol SplashPreparing: ConfigurablePresenter {
    func onStart()
}

protocol SplashLogic: ConfigurableInteractor {
    func onViewLoaded()
}

protocol SplashRouting: ConfigurableRouter {
    func toMain()
}
