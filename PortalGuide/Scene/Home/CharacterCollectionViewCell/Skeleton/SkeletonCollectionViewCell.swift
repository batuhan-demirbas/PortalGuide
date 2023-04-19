//
//  SkeletonCollectionViewCell.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 7.04.2023.
//

import UIKit
import SkeletonView

class SkeletonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var genderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image.showAnimatedGradientSkeleton()
        statusView.showAnimatedGradientSkeleton()
        nameView.showAnimatedGradientSkeleton()
        genderView.showAnimatedGradientSkeleton()

    }

}
