//
//  UIViewController+Extension.swift
//  PortalGuide
//
//  Created by Batuhan on 7.04.2023.
//

import UIKit

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
            let tapGesture = UITapGestureRecognizer(target: self,
                                                     action: #selector(hideKeyboard))
            view.addGestureRecognizer(tapGesture)
        }

        @objc func hideKeyboard() {
            view.endEditing(true)
        }
        
        func someFunction() {
            if isKeyboardVisible() {
                hideKeyboardWhenTappedAround()
            } else {
                print("Klavye kapalı.")
            }
        }
        
        func isKeyboardVisible() -> Bool {
            return view.isFirstResponder
        }
}
