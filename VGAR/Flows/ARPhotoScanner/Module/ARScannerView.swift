//
//  ARScannerView.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import UIKit
import ARKit

class ARScannerView: UIViewController, ARScannerPresenting {
    var interactor: (any ARScannerLogic)?
    
    // MARK: - UI
    private let sceneView = ARSCNView()
    
    private let hintView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .light)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let statusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    
    private let statusStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Найдите изображения с отметкой AR. Чтобы их оживить, наведите камеру на фотографию"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("←", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.darkGray
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 22.5
        button.isEnabled = true
        return button
    }()
    
    private let hintButton: UIButton = {
        let button = UIButton()
        button.setTitle("!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.darkGray
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 22.5
        button.isEnabled = true
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initConstraints()
        
        interactor?.onViewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        interactor?.onViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.onViewWillDisappear()
    }
    
    deinit { print("§ \(self) deinited") }
    
    private func initUI() {
        view.addSubviews(sceneView, backButton, hintButton, hintView, statusView)
        hintView.contentView.addSubview(hintLabel)
        statusView.addSubview(statusStackView)
        statusStackView.addArrangedSubview(loadingIndicator)
        statusStackView.addArrangedSubview(statusLabel)
        
        hintView.isHidden = true
        statusView.isHidden = true
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
        
        sceneView.delegate = self
    }
    
    private func initConstraints() {
        sceneView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(45)
        }
        
        hintButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(45)
        }
        
        hintView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(hintButton.snp.top).offset(-30)
            $0.height.equalTo(0)
        }
        
        hintLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    
        statusView.snp.makeConstraints {
            $0.center.equalTo(sceneView)
            $0.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.4)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.3)
        }
        
        statusStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        interactor?.onBackButtonTapped()
    }
    
    @objc private func hintButtonTapped() {
        interactor?.onHintButtonTapped()
    }
    
    // MARK: - ARScannerPresenting
    func runARSession(with configuration: ARConfiguration) {
        sceneView.session.run(configuration)
    }
    
    func pauseARSession() {
        sceneView.session.pause()
    }
    
    func removeARSession(imageAnchor: ARImageAnchor) {
        sceneView.session.remove(anchor: imageAnchor)
    }
    
    func setHint(_ isVisible: Bool) {
        let targetHeight = isVisible ? (hintLabel.intrinsicContentSize.height + 20) : 0
        let buttonColor = isVisible ? Colors.lightGray1 : Colors.darkGray
        
        hintView.snp.updateConstraints { $0.height.equalTo(targetHeight) }
        
        if isVisible {
            hintView.isHidden = false
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
                self.hintButton.backgroundColor = buttonColor
                self.hintView.alpha = isVisible ? 1 : 0
            }
        ) { _ in
            if !isVisible {
                self.hintView.isHidden = true
            }
        }
    }

    func setLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.statusView.isHidden = false
                self.loadingIndicator.startAnimating()
                self.loadingIndicator.isHidden = false
                self.statusLabel.text = "Загрузка видео..."
                self.statusLabel.textColor = .white
                
                self.view.bringSubviewToFront(self.statusView)
            } else {
                self.statusView.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    func presentError(_ message: String) {
        DispatchQueue.main.async {
            self.statusView.isHidden = false
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            self.statusLabel.text = message
            self.statusLabel.textColor = .red
            
            self.view.bringSubviewToFront(self.statusView)
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                self?.statusView.isHidden = true
                self?.loadingIndicator.isHidden = false
                self?.statusLabel.text = "Загрузка видео..."
                self?.statusLabel.textColor = .white
            }
        }
    }
}

// MARK: - ARSCNViewDelegate
extension ARScannerView: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        interactor?.didAddNode(node, for: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        interactor?.didUpdateNode(node, for: anchor)
    }
}
