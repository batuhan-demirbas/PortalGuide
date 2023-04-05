//
//  LocationCollectionViewCell.swift
//  PortalGuide
//
//  Created by Batuhan on 5.04.2023.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button.titleLabel?.numberOfLines = 1
    }

}
