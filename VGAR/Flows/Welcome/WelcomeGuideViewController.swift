//
//  WelcomeGuideViewController.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import UIKit
import SnapKit

final class WelcomeGuideViewController: UIViewController {
    
    private lazy var welcomeView: WelcomeGuideView = {
        let data = DataLoader.loadGuideData()
        let view = WelcomeGuideView(data)
        return view
    }()
    
    private lazy var continueButton: UIButton = { [weak self] in
        let button = UIButton(type: .system)
          
         let buttonText = NSMutableAttributedString(string: "Продолжить")
         buttonText.addAttribute(.font, value: UIFont.systemFont(ofSize: 19, weight: .bold), range: NSRange(location: 0, length: buttonText.length))
          
         button.setAttributedTitle(buttonText, for: .normal)
         button.setTitleColor(Colors.darkGray, for: .normal)
         button.backgroundColor = Colors.lightGray
         button.layer.cornerRadius = 8
          
         return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initConstraints()
    }
    
    private func initUI() {
        view.backgroundColor = Colors.darkGray
        view.addSubviews(welcomeView, continueButton)
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func initConstraints() {
        welcomeView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(continueButton.snp.top).offset(-30)
        }
        
        continueButton.snp.makeConstraints { make in
            make.width.equalTo(175)
            make.height.equalTo(45)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc private func continueButtonTapped() {
        self.completeGuide()
    }
    
    private func completeGuide() {
        let mainController = MainViewController()
        mainController.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        guard let window = view.window else { return }
        window.layer.add(transition, forKey: kCATransition)
        
        present(mainController, animated: false, completion: nil)
    }
}
