//
//  UIView+Extensions.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
