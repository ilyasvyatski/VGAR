//
//  CacheManager.swift
//  VGAR
//
//  Created by Ilya Svyatski on 30.10.2025.
//

import Foundation

///Manager for user defaults storage, calls with singleton from .shared
class CacheManager {
    ///Here declared all values what we need from defaults
    enum CacheKey: String, CaseIterable {
        case instructionPresented
    }
    
    static var shared = CacheManager()
    private let queue = DispatchQueue(label: "cachingQueue", attributes: .concurrent)
    
    private init() {}
}

//MARK: - Properties
extension CacheManager {
    var instructionPresented: Bool {
        get { getValue(by: .instructionPresented) ?? false }
        set { setValue(by: .instructionPresented, value: newValue) }
    }

    var videosLink: String {
        "https://neoviso.com/arvideo/vg"
    }
    
    var examplePhotosLink: String {
        "https://neoviso.com/vg/"
    }
    
    var supportServiceLink: String {
        "http://www.bybook.by/?page=about"
    }
}

//MARK: - Public functions
extension CacheManager {
    func clearCache() {
        CacheKey.allCases.filter({ $0 != .instructionPresented}).forEach({
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        })
    }
}

//MARK: - Private functions
extension CacheManager {
    private func getValue<T: Decodable>(by key: CacheKey) -> T? {
        queue.sync() {
            guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data else { return nil }
            return try? JSONDecoder().decode(T.self , from: data)
        }
    }
    
    private func setValue<T: Encodable>(by key: CacheKey, value: T?) {
        queue.async(group: nil, qos: .userInitiated, flags: .barrier) {
            let object = try? JSONEncoder().encode(value)
            UserDefaults.standard.set(object, forKey: key.rawValue)
        }
    }
}
