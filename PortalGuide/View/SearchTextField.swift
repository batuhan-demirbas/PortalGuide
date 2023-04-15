//
//  SearchTextField.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 4.04.2023.
//

import UIKit

@IBDesignable
class SearchTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        
        guard let placeholder = self.placeholder else {return}
        self.attributedPlaceholder = NSAttributedString(
            string: "\(placeholder)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Grey.normal]
        )
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 52))
        let imageView = UIImageView(frame: CGRect(x: 16, y: (view.frame.size.height - 24) / 2, width: 24, height: 24))
        imageView.image = UIImage(named: "search")
        imageView.tintColor = .Grey.normal
        view.addSubview(imageView)
        leftView = view
        leftViewMode = .always
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    @IBInspectable
    var cornerRadius:Double {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
}

extension SearchTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 1.3
        textField.layer.borderColor = UIColor.primary.cgColor
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 0
        return true
    }
    
    
}
