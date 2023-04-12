//
//  DetailViewController.swift
//  PortalGuide
//
//  Created by Batuhan on 5.04.2023.
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
        configure()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if UIDevice.current.orientation.isLandscape {
            if let constraints = imageView.superview?.constraints {
                for constraint in constraints {
                    constraint.isActive = false
                }
            }
            self.stackView.axis = .horizontal
            
        } else {
            if let constraints = imageView.superview?.constraints {
                for constraint in constraints {
                    constraint.isActive = true
                }
            }
            stackView.removeConstraint(stackView.constraints.last!)
            self.stackView.axis = .vertical
        }
        
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
    
}
