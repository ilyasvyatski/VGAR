//
//  ARPhotoScannerProtocols.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import Foundation
import ARKit
import SceneKit

protocol ARScannerPresenting: ConfigurableView {
    func runARSession(with configuration: ARConfiguration)
    func pauseARSession()
    func removeARSession(imageAnchor: ARImageAnchor)
    func setHint(_ isVisible: Bool)
    func setLoading(_ isLoading: Bool)
    func presentError(_ message: String)
}

protocol ARScannerPreparing: ConfigurablePresenter {
    func setupARSession()
    func removeARSession(imageAnchor: ARImageAnchor)
    func pauseARSession()
    func setHint(_ isVisible: Bool)
    func setLoading(_ isLoading: Bool)
    func presentError(_ message: String)
    func toInstruction()
}

protocol ARScannerLogic: ConfigurableInteractor {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
    func onBackButtonTapped()
    func onHintButtonTapped()
    func didAddNode(_ node: SCNNode, for anchor: ARAnchor)
    func didUpdateNode(_ node: SCNNode, for anchor: ARAnchor)
}

protocol ARScannerRouting: ConfigurableRouter {
    func toInstruction()
}
