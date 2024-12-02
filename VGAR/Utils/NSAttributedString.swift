//
//  NSAttributedString.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import Foundation

// NSAttributedString extension for creating hyperlinks
extension NSAttributedString {
//    static func makeHyperLink(for path: String, in string: String, as substring: String)
//    -> NSAttributedString {
//        let result = NSMutableAttributedString(string: string)
//        let tempString = NSString(string: string)
//        let substringRange = tempString.range(of: substring)
//        result.addAttribute(.link, value: path, range: substringRange)
//        return result
//    }
    static func makeHyperLink(for paths: [String], in string: String, as substrings: [String]) -> NSAttributedString {
            let result = NSMutableAttributedString(string: string)
            let tempString = NSString(string: string)
             
            for (index, substring) in substrings.enumerated() {
                if index < paths.count {
                    let substringRange = tempString.range(of: substring)
                    result.addAttribute(.link, value: paths[index], range: substringRange)
                }
            }
             
            return result
        }
}
