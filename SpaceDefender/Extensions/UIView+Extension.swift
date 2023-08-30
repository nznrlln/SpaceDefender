//
//  UIView+Extension.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 19.08.2023.
//

import UIKit

extension UIView {

    static var identifier: String {
        String(describing: Self.self)
    }

    func toAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
