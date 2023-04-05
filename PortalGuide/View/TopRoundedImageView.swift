//
//  TopRoundedImageView.swift
//  PortalGuide
//
//  Created by Batuhan on 5.04.2023.
//

import UIKit

@IBDesignable
class TopRoundedImageView: UIImageView {
    
    @IBInspectable var topCornerRadius: CGFloat = 0.0 {
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
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: topCornerRadius, height: topCornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
}
