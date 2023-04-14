//
//  HomeCollectionViewCell.swift
//  PortalGuide
//
//  Created by Batuhan on 5.04.2023.
//

import UIKit
import Kingfisher

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    var character: Character?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        let imageURL = URL(string: character?.image ?? "")
        characterImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        
        switch character?.gender?.lowercased() {
        case Gender.male.rawValue:
            genderImageView.image = UIImage(named: Gender.male.icon)
            genderImageView.tintColor = .Gender.male
        case Gender.female.rawValue:
            genderImageView.image = UIImage(named: Gender.female.icon)
            genderImageView.tintColor = .Gender.female
        default:
            genderImageView.image = UIImage(named: Gender.unknown.icon)
            genderImageView.tintColor = .Gender.unknown
        }
        
        statusLabel.text = character?.status?.capitalized
        switch character?.status?.lowercased() {
        case Status.alive.rawValue:
            statusLabel.textColor = .Status.alive
        case Status.dead.rawValue:
            statusLabel.textColor = .Status.dead
        default:
            statusLabel.textColor = .Status.unknown
        }
        
        nameLabel.text = character?.name
        
        if character?.type == "" {
            speciesLabel.text = character?.species
        } else {
            speciesLabel.text = (character?.species ?? "") + " · " + (character?.type ?? "")
        }
        
    }

}
