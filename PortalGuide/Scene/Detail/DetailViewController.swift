//
//  DetailViewController.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 5.04.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var specyLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    var character: Character?
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustUIForOrientation()
        configure()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        adjustUIForOrientation()
        
    }
    
    func configure() {
        guard let character = character else { return }

        let episodes = viewModel.filterEpisodeURLs(episodeURLs: character.episode)
        let imageURL = URL(string: character.image ?? "")

        title = character.name
        imageView.kf.setImage(with: imageURL)
        statusLabel.text = character.status
        specyLabel.text = character.species
        genderLabel.text = character.gender
        originLabel.text = character.origin?.name
        locationLabel.text = character.location?.name
        episodesLabel.text = episodes.joined(separator: ", ")
        createdLabel.text = character.created?.convertToCustomDateFormat()
    }
    
    func adjustUIForOrientation() {
        if UIDevice.current.orientation.isLandscape {
            imageView.superview?.constraints.forEach { $0.isActive = false }
            stackView.axis = .horizontal
        } else {
            imageView.superview?.constraints.forEach { $0.isActive = true }
            stackView.removeConstraint(stackView.constraints.last!)
            stackView.axis = .vertical
        }
    }
    
}
