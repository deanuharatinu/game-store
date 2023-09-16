//
//  UIExtensions.swift
//  GameStore
//
//  Created by Deanu Haratinu on 16/09/23.
//

import UIKit

extension UIImageView {
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 0.95)
        self.layer.addSublayer(gradient)
    }
}
