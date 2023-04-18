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
        viewModel.errorCallback = { errorMessage in
            print("error: \(errorMessage)")
        }
        viewModel.successCallback = { [weak self] in
            self?.viewModel.selectedLocation = self?.viewModel.location?.results.first
            
            self?.viewModel.filterCharacterIds(location: (self?.viewModel.selectedLocation!)!)
            guard let characterIds = self?.viewModel.characterIdsInSelectedLocation else { return }
            guard let location = self?.viewModel.location else { return }
            
            self?.viewModel.getCharactersByIds(ids: characterIds)
            self?.viewModel.successCallback = { [weak self] in
                let sender: HomeData = HomeData(location: location, characters: self?.viewModel.characters)
                self?.performSegue(withIdentifier: "showHome", sender: sender)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHome", let navController = segue.destination as? UINavigationController, let homeVC = navController.children.first as? HomeViewController, let homeData = sender as? HomeData {
                homeVC.homeData = homeData
            }
    }
    
    func updateMessageLabel() {
        if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
            messageLabel.text = "Hello!"
        }
    }
    
}
