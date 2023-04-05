//
//  DetailViewController.swift
//  PortalGuide
//
//  Created by Batuhan on 5.04.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var specyLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configure() {
        let imageURL = URL(string: character?.image ?? "")
        imageView.kf.setImage(with: imageURL)
        
        statusLabel.text = character?.status
        specyLabel.text = character?.species
        genderLabel.text = character?.gender
        originLabel.text = character?.origin?.name
        locationLabel.text = character?.location?.name
        episodesLabel.text = character?.episode?.first
        createdLabel.text = character?.created
    }
    
    @IBAction func backButtonTapped(_ sender:UIButton) {
        dismiss(animated: true)
    }

}
