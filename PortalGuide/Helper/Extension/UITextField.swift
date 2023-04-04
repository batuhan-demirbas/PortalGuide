//
//  UITextField.swift
//  PortalGuide
//
//  Created by Batuhan on 4.04.2023.
//

import UIKit

extension UITextField {
    
    enum Direction
    {
        case Left
        case Right
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x:0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    
    func addIcon(direction:Direction,imageName:String,Frame:CGRect)
    {
        let View = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 24))
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = UIImage(named: imageName)
        
        View.addSubview(imageView)
        
        if Direction.Left == direction
        {
            self.leftViewMode = .always
            self.leftView = View
        }
        else
        {
            self.rightViewMode = .always
            self.rightView = View
        }
    }
    
}
