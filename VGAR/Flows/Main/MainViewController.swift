//
//  ViewController.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import UIKit
import SnapKit
import SceneKit
import ARKit
import AVFoundation

class MainViewController: UIViewController, ARSCNViewDelegate {
    
    let sceneView = ARSCNView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("←", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.darkGray
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 22.5
        button.isEnabled = true
        return button
    }()
    
    private lazy var hintButton: UIButton = {
        let button = UIButton()
        button.setTitle("!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.darkGray
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 22.5
        button.isEnabled = true
        return button
    }()
    
    private lazy var hintView: UIVisualEffectView = {
        let hintView = UIVisualEffectView()
        hintView.effect = UIBlurEffect(style: .light)
        hintView.layer.cornerRadius = 8
        hintView.clipsToBounds = true
        return hintView
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Найдите изображения с отметкой AR из специальной книги о издательском доме «Вечерний Гомель-Медиа». Чтобы их оживить, наведите камеру на фотографию"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.isUserInteractionEnabled = true
        label.sizeToFit()
        return label
    }()
    
    private let videoPlayerQueue = DispatchQueue(label: "com.example.videoPlayerQueue")

    lazy var videoPlayer: AVPlayer = {
        return AVPlayer()
    }()
    
    lazy var videoNode: SKVideoNode = {
        return SKVideoNode()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureARImageTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        removeVideoPlayerItemObserver()
    }
    
    private func initUI() {
        view.addSubviews(sceneView, backButton, hintButton, hintView)
        hintView.contentView.addSubview(hintLabel)
        hintView.isHidden = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
        
        sceneView.delegate = self
    }
    
    private func initConstraints() {
        sceneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(45)
        }
        
        hintButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(45)
        }
        
        hintView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(hintButton.snp.top).offset(-30)
            make.height.equalTo(0)
        }
        
        hintLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    @objc private func backButtonTapped() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        
        guard let window = view.window else { return }
        window.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func hintButtonTapped() {
        if hintView.isHidden {
            hintView.isHidden = false
            hintButton.backgroundColor = Colors.lightGray1
            hintView.snp.updateConstraints { make in
                make.height.equalTo(hintLabel.intrinsicContentSize.height + 20)
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.hintView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.view.layoutIfNeeded()
            }) { _ in
                self.hintView.isHidden = true
                self.hintButton.backgroundColor = Colors.darkGray
            }
        }
    }
    
//    deinit {
//        removeVideoPlayerItemObserver()
//    }
}

extension MainViewController {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        if let _ = node.childNodes.first {
            return
        }
        
        let referenceImageSize = imageAnchor.referenceImage.physicalSize
        let planeVideo = SCNPlane(width: referenceImageSize.width, height: referenceImageSize.height)
        
        if let target = imageAnchor.referenceImage.name {
            loadVideo(for: target) { [weak self] in
                DispatchQueue.main.async {
                    if let videoScene = self?.videoScene() {
                        planeVideo.firstMaterial?.diffuse.contents = videoScene
                        let planeVideoNode = SCNNode(geometry: planeVideo)
                        planeVideoNode.eulerAngles.x = -Float.pi / 2
                        node.addChildNode(planeVideoNode)
                        self?.playVideo()
                    }
                }
            }
        }
    }
    
    private func loadVideo(for target: String, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            guard let videoURL = URL(string: "https://neoviso.com/arvideo/vg/\(target).mp4") else {
                return
            }
            
            do {
                let videoItem = AVPlayerItem(url: videoURL)
                self.videoPlayerQueue.async {
                    self.replaceCurrentItem(with: videoItem)
                    self.videoPlayer.actionAtItemEnd = .none
                    self.addVideoPlayerItemObserver()
                    completion()
                }
            } catch {
                print("Error loading video: \(error)")
            }
        }
    }
    
    private func videoScene() -> SKScene? {
        let videoScene = SKScene(size: CGSize(width: 1920, height: 1080))
        videoNode = SKVideoNode(avPlayer: videoPlayer)
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.yScale = -1.0
        videoNode.size = videoScene.size
        videoScene.backgroundColor = .clear
        videoScene.addChild(videoNode)
        //self.playVideo()
        return videoScene
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        if node.isHidden {
            sceneView.session.remove(anchor: imageAnchor)
            videoPlayerQueue.async {
                self.videoPlayer.pause()
            }
        }
    }
    
    @objc private func loopVideo() {
        videoPlayerQueue.async {
            self.videoPlayer.seek(to: .zero)
        }
    }
    
    private func playVideo() {
        videoPlayerQueue.async {
            self.videoPlayer.play()
        }
    }
    
    private func stopVideo() {
        videoPlayerQueue.async {
            self.videoPlayer.pause()
        }
    }
    
    private func configureARImageTrackingConfiguration() {
        let configuration = ARImageTrackingConfiguration()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else {
            fatalError("Failed to load the reference images")
        }
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration)
    }
    
    private func replaceCurrentItem(with playerItem: AVPlayerItem) {
        videoPlayerQueue.async {
            if let currentPlayerItem = self.videoPlayer.currentItem {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: currentPlayerItem)
            }
            
            self.videoPlayer.replaceCurrentItem(with: playerItem)
        }
    }
    
    private func addVideoPlayerItemObserver() {
        videoPlayerQueue.async {
            guard let currentPlayerItem = self.videoPlayer.currentItem else {
                return
            }
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: currentPlayerItem,
                queue: nil
            ) { [weak self] _ in
                self?.loopVideo()
            }
        }
    }
    
    private func removeVideoPlayerItemObserver() {
        videoPlayerQueue.async { [weak self] in
            if let currentPlayerItem = self?.videoPlayer.currentItem {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: currentPlayerItem)
            }
        }
    }
}
