//
//  UILabel+Ext.swift
//  VGAR
//
//  Created by Ilya Svyatski on 29.10.2025.
//

import UIKit

private var tapHandlerKey: UInt8 = 0

extension UILabel {
    private var tapHandlers: [String: () -> Void] {
        get {
            objc_getAssociatedObject(self, &tapHandlerKey) as? [String: () -> Void] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &tapHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.text else { return }
        for (tappableText, handler) in tapHandlers {
            let stringRange = (text as NSString).range(of: tappableText)
            if gesture.didTapAttributedTextInLabel(label: self, inRange: stringRange) {
                handler()
            }
        }
    }
    
    func addTappable(text: String, tapHandler: @escaping () -> Void) {
        if gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) == nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_:)))
            tapGesture.numberOfTapsRequired = 1
            addGestureRecognizer(tapGesture)
            isUserInteractionEnabled = true
        }
        
        tapHandlers[text] = tapHandler
    }
}
