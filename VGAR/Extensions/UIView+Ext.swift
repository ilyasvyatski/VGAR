//
//  UIView+Extensions.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
