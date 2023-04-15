//
//  LeftRoundedImageView.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 14.04.2023.
//

import UIKit

@IBDesignable
class LeftRoundedImageView: UIImageView {
    
    @IBInspectable var leftCornerRadius: CGFloat = 0.0 {
        didSet {
            setUpView()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }
    
    private func setUpView() {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .bottomLeft],
                                cornerRadii: CGSize(width: leftCornerRadius, height: leftCornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
}
