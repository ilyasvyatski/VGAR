//
//  InstructionPresenter.swift
//  VGAR
//
//  Created by Ilya Svyatski on 29.10.2025.
//

import Foundation

class InstructionPresenter: InstructionPreparing {
    weak var view: (any InstructionPresenting)?
    var router: (any InstructionRouting)?
    
    func toARScanner() {
        router?.toARScanner()
    }
    
    func toLink(_ link: String) {
        router?.toLink(link)
    }
}
