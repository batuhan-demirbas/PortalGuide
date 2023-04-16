//
//  UICollectionView+Extension.swift
//  PortalGuide
//
//  Created by Batuhan on 16.04.2023.
//

import UIKit

extension UICollectionView {
    func scrollTop() {
        if self.numberOfItems(inSection: 0) > 0 {
            let topOffset = CGPoint(x: 0, y: -self.contentInset.top)
            self.setContentOffset(topOffset, animated: true)
        }
    }
    
}
