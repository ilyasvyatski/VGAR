//
//  ARScannerInteractor.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import Foundation
import AVFoundation
import SpriteKit
import ARKit
import SceneKit

class ARScannerInteractor: ARScannerLogic {
    
    var presenter: (any ARScannerPreparing)?
    
    private let videoQueue = DispatchQueue(label: "com.arscanner.video", qos: .userInitiated)
    
    private struct VideoCache {
        let player: AVPlayer
        let scene: SKScene
    }
    
    private var videoCache: [String: VideoCache] = [:]
    
    private var isHintVisible = false
    private var isLoadingVideo = false
    private var currentVideoName: String?
    
    func onViewLoaded() {}
    
    func onViewWillAppear() {
        presenter?.setupARSession()
    }
    
    func onViewWillDisappear() {
        stopAllVideos()
        removeAllObservers()
        presenter?.pauseARSession()
        presenter?.setLoading(false)
    }
    
    func onBackButtonTapped() {
        presenter?.toInstruction()
    }
    
    func onHintButtonTapped() {
        isHintVisible.toggle()
        presenter?.setHint(isHintVisible)
    }
    
    func didAddNode(_ node: SCNNode, for anchor: ARAnchor) {
        guard
            let imageAnchor = anchor as? ARImageAnchor,
            let imageName = imageAnchor.referenceImage.name,
            node.childNodes.isEmpty,
            !isLoadingVideo
        else { return }
        
        print("🟡 Detected AR Image: '\(imageName)'")
        stopCurrentVideo()
        
        if let cache = videoCache[imageName] {
            print("💾 Video found in CACHE: '\(imageName)'")
            setupVideoNode(
                on: node,
                with: cache.scene,
                imageSize: imageAnchor.referenceImage.physicalSize,
                target: imageName
            )
            
            playVideo(for: imageName, player: cache.player)
        } else {
            print("🌐 Video NOT in cache - DOWNLOADING: '\(imageName)'")
            loadVideo(for: imageName, anchor: imageAnchor, node: node)
        }
    }
    
    func didUpdateNode(_ node: SCNNode, for anchor: ARAnchor) {
        guard
            let imageAnchor = anchor as? ARImageAnchor,
            node.isHidden,
            let imageName = imageAnchor.referenceImage.name
        else { return }
        
        print("🟡 Node hidden: \(imageName)")
        
        if isLoadingVideo, imageName == currentVideoName {
            isLoadingVideo = false
            presenter?.setLoading(false)
        }
        
        stopCurrentVideo()
        presenter?.removeARSession(imageAnchor: imageAnchor)
    }
}

private extension ARScannerInteractor {
    func loadVideo(for target: String, anchor: ARImageAnchor, node: SCNNode) {
        isLoadingVideo = true
        presenter?.setLoading(true)
        
        videoQueue.async { [weak self] in
            guard let self else { return }

            guard let url = URL(string: "https://neoviso.com/arvideo/vg/\(target).mp4") else {
                self.showError("Неверная ссылка на видео")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            request.timeoutInterval = 5
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error as NSError? {
                    let message = error.code == NSURLErrorNotConnectedToInternet ?
                    "Нет подключения к интернету" : "Ошибка загрузки видео"
                    self.showError(message)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showError("Неверный ответ сервера")
                    return
                }
                
                if httpResponse.statusCode == 404 {
                    self.showError("Видео не найдено")
                    return
                } else if !(200...299).contains(httpResponse.statusCode) {
                    self.showError("Ошибка загрузки видео")
                    return
                }
                
                DispatchQueue.main.async {
                    let player = AVPlayer(url: url)
                    player.actionAtItemEnd = .none
                    
                    if player.currentItem?.status == .failed {
                        self.showError("Не удалось загрузить видео")
                        return
                    }
                    
                    self.addVideoEndObserver(for: target, player: player)
                    let scene = self.createVideoScene(player: player)
                    let cache = VideoCache(player: player, scene: scene)
                    
                    self.videoCache[target] = cache
                    self.setupVideoNode(
                        on: node,
                        with: scene,
                        imageSize: anchor.referenceImage.physicalSize,
                        target: target
                    )
                    self.playVideo(for: target, player: player)
                    print("🟢 Load success")
                }
            }
            
            task.resume()
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoadingVideo = false
            self?.presenter?.presentError(message)
            print("🔴 Load failed")
        }
    }
    
    func createVideoScene(player: AVPlayer) -> SKScene {
        let scene = SKScene(size: CGSize(width: 1920, height: 1080))
        let videoNode = SKVideoNode(avPlayer: player)
        
        videoNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        videoNode.yScale = -1.0
        videoNode.size = scene.size
        
        scene.backgroundColor = .clear
        scene.addChild(videoNode)
        
        return scene
    }
//    
//    func setupVideoNode(on node: SCNNode, with scene: SKScene, imageSize: CGSize) {
//        let plane = SCNPlane(width: imageSize.width, height: imageSize.height)
//        plane.firstMaterial?.diffuse.contents = scene
//        
//        let planeNode = SCNNode(geometry: plane)
//        planeNode.eulerAngles.x = -Float.pi / 2
//        node.addChildNode(planeNode)
//    }
    
    func setupVideoNode(
        on node: SCNNode,
        with scene: SKScene,
        imageSize: CGSize,
        target: String? = nil
    ) {
        let plane = createVideoPlane(for: target, imageSize: imageSize)
        plane.firstMaterial?.diffuse.contents = scene
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -Float.pi / 2
        node.addChildNode(planeNode)
    }
    
    func createVideoPlane(for target: String?, imageSize: CGSize) -> SCNPlane {
        guard let target = target else {
            return SCNPlane(width: imageSize.width, height: imageSize.height)
        }
        
        switch target {
        case "vg_1":
            let videoWidth: CGFloat = 1920.0
            let videoHeight: CGFloat = 1080.0
            
            let scaledHeight = imageSize.height
            let scaledWidth = (scaledHeight / videoHeight) * videoWidth
            return SCNPlane(width: scaledWidth, height: scaledHeight)
        default:
            return SCNPlane(width: imageSize.width, height: imageSize.height)
        }
    }
    
    func playVideo(for target: String, player: AVPlayer) {
        videoQueue.async { [weak self] in
            player.seek(to: .zero) { _ in
                player.play()
                self?.currentVideoName = target
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    self?.isLoadingVideo = false
                    self?.presenter?.setLoading(false)
                }
                
                print("🟢 Playing: \(target)")
            }
        }
    }
    
    func stopCurrentVideo() {
        videoQueue.async { [weak self] in
            if let currentName = self?.currentVideoName,
               let player = self?.videoCache[currentName]?.player {
                player.pause()
                print("🟡 Stopped: \(currentName)")
            }
            self?.currentVideoName = nil
        }
    }
    
    func stopAllVideos() {
        videoQueue.async { [weak self] in
            self?.videoCache.values.forEach { $0.player.pause() }
            self?.currentVideoName = nil
        }
    }
    
    func addVideoEndObserver(for target: String, player: AVPlayer) {
           NotificationCenter.default.addObserver(
               forName: .AVPlayerItemDidPlayToEndTime,
               object: player.currentItem,
               queue: .main
           ) { [weak self] _ in
               print("🔄 Video finished - restarting: \(target)")
               self?.videoQueue.async {
                   player.seek(to: .zero) { _ in
                       player.play()
                       print("🟢 Video restarted: \(target)")
                   }
               }
           }
       }
       
    func removeAllObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
