//
//  DataLoader.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import Foundation

private enum DefaultFilePaths {
    static let guideData = "welcomeGuideData.json"
}

public final class DataLoader {
    
    static func loadGuideData(_ filename: String = DefaultFilePaths.guideData) -> WelcomeGuideModel {
        WelcomeGuideModel(textBlocks: loadData(filename))
    }
    
    private static func loadData<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
