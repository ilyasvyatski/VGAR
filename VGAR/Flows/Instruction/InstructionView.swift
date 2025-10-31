//
//  InstructionView.swift
//  VGAR
//
//  Created by Ilya Svyatski on 29.10.2025.
//

import UIKit

class InstructionView: UIViewController, InstructionPresenting {
    var interactor: (any InstructionLogic)?
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let header = UILabel()
        header.text = "Добро пожаловать!"
        header.numberOfLines = 1
        header.font = .systemFont(ofSize: 28, weight: .bold)
        header.contentMode = .left
        header.textColor = Colors.lightGray
        return header
    }()

    private let instructionView = InstructionContentView()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonText = NSMutableAttributedString(string: "Продолжить")
        buttonText.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 16, weight: .semibold),
            range: NSRange(location: 0, length: buttonText.length)
        )
        button.setAttributedTitle(buttonText, for: .normal)
        button.setTitleColor(Colors.darkGray, for: .normal)
        button.backgroundColor = Colors.lightGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initConstraints()
        
        CacheManager.shared.instructionPresented = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit { print("§ \(self) deinited") }
    
    private func initUI() {
        view.backgroundColor = Colors.darkGray
        
        view.addSubviews(titleLabel, instructionView, continueButton)
        
        instructionView.delegate = self
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func initConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        instructionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(48)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        continueButton.snp.makeConstraints {
            $0.top.equalTo(instructionView.snp.bottom).offset(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(175)
            $0.height.equalTo(45)
        }
    }
    
    // MARK: - Actions
    @objc private func continueButtonTapped() {
        interactor?.onContinueButtonTapped()
    }
}

extension InstructionView: InstructionContentViewDelegate {
    func didTapLink(_ type: InstructionContentView.InstructionLinkType) {
        type == .supportService ?
        interactor?.onSupportServiceTapped() :
        interactor?.onExamplePhotosTapped()
    }
}
