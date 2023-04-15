//
//  SplashViewController.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 10.04.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    let viewModel = HomeViewModel()
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMessageLabel()
        viewModelConfiguration()
    }
    
    fileprivate func viewModelConfiguration() {
        viewModel.getLocation(page: "1")
        viewModel.errorCallback = { [weak self] errorMessage in
            print("error: \(errorMessage)")
        }
        viewModel.successCallback = { [weak self] in
            let homeVC = HomeViewController()
            homeVC.selectedLocation = self?.viewModel.location?.results.first
            
            homeVC.characterIdsInSelectedLocation = self?.viewModel.filterCharacterIds(location: (homeVC.selectedLocation)!)
            guard let characterIds = homeVC.characterIdsInSelectedLocation else { return }
            self?.viewModel.getCharactersByIds(ids: characterIds)
            self?.viewModel.successCallback = { [weak self] in
                homeVC.filteredCharacters = self?.viewModel.characters
                _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                    self?.performSegue(withIdentifier: "showHome", sender: nil)
                    
                }
            }
        }
    }
    
    func updateMessageLabel() {
        if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
            messageLabel.text = "Hi"
        }
    }
}
