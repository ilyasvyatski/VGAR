//
//  ARScannerPresenter.swift
//  VGAR
//
//  Created by Ilya Svyatski on 27.10.2025.
//

import Foundation
import ARKit

class ARScannerPresenter: ARScannerPreparing {
    weak var view: (any ARScannerPresenting)?
    var router: (any ARScannerRouting)?
    
    func setupARSession() {
        let configuration = ARImageTrackingConfiguration()
        
        guard
            let referenceImages = ARReferenceImage.referenceImages(
                inGroupNamed: "AR Resources", bundle: .main
            )
        else {
            print("🔴 Failed to load reference images")
            return
        }
            
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
            
        view?.runARSession(with: configuration)
    }
    
    func removeARSession(imageAnchor: ARImageAnchor) {
        view?.removeARSession(imageAnchor: imageAnchor)
    }
        
    func pauseARSession() {
        view?.pauseARSession()
    }
    
    func setHint(_ isVisible: Bool) {
        view?.setHint(isVisible)
    }
    
    func setLoading(_ isLoading: Bool) {
        view?.setLoading(isLoading)
    }
    
    func presentError(_ message: String) {
        view?.presentError(message)
    }
    
    func toInstruction() {
        router?.toInstruction()
    }
}
