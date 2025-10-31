//
//  BaseNavigationController.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import UIKit
import SnapKit

class BaseNavigationController: UINavigationController {
    private lazy var loadingView: LoadingView = {
        LoadingView()
    }()
    
    ///Overrided for set back button title
    override init(rootViewController: UIViewController) {
        rootViewController.navigationItem.backButtonTitle = "Назад"
        super.init(rootViewController: rootViewController)
        setupUI()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///Overrided for set back button title
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backButtonTitle = "Назад"
        super.pushViewController(viewController, animated: animated)
    }
    
    ///Push vc with clear nav bar shadow
    func pushViewControllerWithoutShadow(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backButtonTitle = "Назад"
        super.pushViewController(viewController, animated: animated)
        clearShadowForCurrentVC()
    }
    
    ///Set navigation bar without shadow
    func clearShadowForCurrentVC() {
        guard let current = topViewController else { return }
        let appearance = UINavigationBar.appearance().standardAppearance.copy()
        appearance.shadowColor = nil
        current.navigationItem.standardAppearance = appearance
        current.navigationItem.compactAppearance = appearance
        current.navigationItem.scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            current.navigationItem.compactScrollEdgeAppearance = appearance
        } 
    }
    
    private func setupUI() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.bringSubviewToFront(self.loadingView)
            isLoading
            ? self.loadingView.startAnimating()
            : self.loadingView.stopAnimating()
        }
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
