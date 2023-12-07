//
//  Extensions.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/31.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
