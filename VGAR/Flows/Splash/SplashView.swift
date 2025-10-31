//
//  SplashView.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import UIKit
import SnapKit

class SplashView: UIViewController, SplashPresenting {
    var interactor: (any SplashLogic)?
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .logo)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initConstraints()
        
        interactor?.onViewLoaded()
    }
    
    deinit { print("§ \(self) deinited") }
    
    private func initUI() {
        view.backgroundColor = .white
        
        view.addSubview(logoImageView)
    }
    
    private func initConstraints() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
    }
}
