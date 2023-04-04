//
//  ViewController.swift
//  PortalGuide
//
//  Created by Batuhan on 27.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    private var characterIdsInSelectedLocation: [String]?
    
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModelConfiguration()
    }
    
    fileprivate func viewModelConfiguration() {
        viewModel.getLocation()
        viewModel.errorCallback = { [weak self] errorMessage in
            print("error: \(errorMessage)")
        }
        viewModel.successCallback = { [weak self] in
            guard let selectedLocation = self?.viewModel.location?.results?.first else {return}
            self?.locationLabel.text = selectedLocation.name
            self?.characterIdsInSelectedLocation = self?.viewModel.filterCharacterIds(location: selectedLocation)
            print(self?.characterIdsInSelectedLocation)
            guard let characterIds = self?.characterIdsInSelectedLocation else { return }
            self?.viewModel.getCharactersByIds(ids: characterIds)
            self?.viewModel.successCallback = { [weak self] in
                print(self?.viewModel.characters?.first?.name)
                
            }
        }
    }
    
    

}

