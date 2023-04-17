//
//  UIDeviceOriantation.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 17.04.2023.
//

import UIKit

extension UIWindowScene {
    var isLandscape: Bool {
        return self.interfaceOrientation.isLandscape
    }
}
