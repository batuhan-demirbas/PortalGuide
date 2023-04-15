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
            self?.viewModel.selectedLocation = self?.viewModel.location?.results.first
            
            self?.viewModel.filterCharacterIds(location: (self?.viewModel.selectedLocation!)!)
            guard let characterIds = self?.viewModel.characterIdsInSelectedLocation else { return }
            
            self?.viewModel.getCharactersByIds(ids: characterIds)
            self?.viewModel.successCallback = { [weak self] in
                homeVC.viewModel.filteredCharacters = self?.viewModel.characters
                _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                    self?.performSegue(withIdentifier: "showHome", sender: nil)
                    
                }
            }
        }
    }
    
    func updateMessageLabel() {
        if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
            messageLabel.text = "Hello!"
        }
    }
}
