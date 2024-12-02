//
//  WelcomeGuideModel.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

struct WelcomeGuideModel {
    let textBlocks: [WelcomeGuideTextBlock]
}

struct WelcomeGuideTextBlock: Decodable, Identifiable {
    let id: Int
    let description: String
    let imageName: String?
}
