//
//  ModuleConfigurator.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import Foundation
import UIKit

// All VIP modules must inherite this protocols

protocol ConfigurableView<Interactor>: AnyObject {
    associatedtype Interactor
    var interactor: Interactor? { get set }
}

protocol ConfigurablePresenter<View, Router>: AnyObject {
    associatedtype View
    associatedtype Router
    var view: View? { get set }
    var router: Router? { get set }
}

protocol ConfigurableInteractor<Presenter>: AnyObject {
    associatedtype Presenter
    var presenter: Presenter? { get set }
}

protocol ConfigurableRouter: AnyObject {
    var view: UIViewController? { get set }
}

///General VIP module configurator
class ModuleConfigurator {
    /// Creates generic module
    func configure<View: ConfigurableView,
                   Presenter: ConfigurablePresenter,
                   Interactor: ConfigurableInteractor,
                   Router: ConfigurableRouter>
    (vc: View, presenter: Presenter?, interactor: Interactor?, router: Router?) {
        vc.interactor = interactor as? View.Interactor
        presenter?.view = vc as? Presenter.View
        presenter?.router = router as? Presenter.Router
        interactor?.presenter = presenter as? Interactor.Presenter
        router?.view = vc as? UIViewController
    }
}
