//
//  InstructionProtocols.swift
//  VGAR
//
//  Created by Ilya Svyatski on 29.10.2025.
//

protocol InstructionPresenting: ConfigurableView {}

protocol InstructionPreparing: ConfigurablePresenter {
    func toARScanner()
    func toLink(_ link: String)
}

protocol InstructionLogic: ConfigurableInteractor {
    func onSupportServiceTapped()
    func onExamplePhotosTapped()
    func onContinueButtonTapped()
}

protocol InstructionRouting: ConfigurableRouter {
    func toARScanner()
    func toLink(_ link: String)
}
