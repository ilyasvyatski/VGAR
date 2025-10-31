//
//  InstructionInteractor.swift
//  VGAR
//
//  Created by Ilya Svyatski on 29.10.2025.
//

class InstructionInteractor: InstructionLogic {
    var presenter: (any InstructionPreparing)?
    
    private let cacheManager = CacheManager.shared
    private var supportServiceLink: String { cacheManager.supportServiceLink }
    private var examplePhotosLink: String { cacheManager.examplePhotosLink }
    
    func onSupportServiceTapped() {
        presenter?.toLink(supportServiceLink)
    }
       
    func onExamplePhotosTapped() {
        presenter?.toLink(examplePhotosLink)
    }
    
    func onContinueButtonTapped() {
        presenter?.toARScanner()
    }
}
