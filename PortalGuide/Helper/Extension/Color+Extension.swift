//
//  Color+Extension.swift
//  PortalGuide
//
//  Created by Batuhan on 13.04.2023.
//

import Foundation
import UIKit

extension UIColor {

    // MARK: - Gender Colors
    class Gender {
        static let male = UIColor(named: "gender.male")!
        static let unknown = UIColor(named: "gender.unknown")!
        static let female = UIColor(named: "gender.female")!
    }
    
    // MARK: - Grey Colors
    class Grey {
       
        static let light = UIColor(named: "grey.light")!
        static let normal = UIColor(named: "grey.normal")!
        static let dark = UIColor(named: "grey.dark")!
    }
    
    // MARK: - Primary Colors
    static let primary = UIColor(named: "primary")!
    
    // MARK: - Status Colors
    class Status {
        static let alive = UIColor(named: "status.alive")!
        static let unknown = UIColor(named: "status.unknown")!
        static let dead = UIColor(named: "status.dead")!
    }
}
