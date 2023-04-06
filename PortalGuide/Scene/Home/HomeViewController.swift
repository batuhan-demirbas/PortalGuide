//
//  ViewController.swift
//  PortalGuide
//
//  Created by Batuhan on 27.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    private var characterIdsInSelectedLocation: [String]?
    private var selectedLocation: ResultElement?
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        viewModelConfiguration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func viewModelConfiguration() {
        viewModel.getLocation()
        viewModel.errorCallback = { [weak self] errorMessage in
            print("error: \(errorMessage)")
        }
        viewModel.successCallback = { [weak self] in
            self?.locationCollectionView.reloadData()
            if self?.selectedLocation == nil {
                self?.selectedLocation = self?.viewModel.location?.results?.first
            }
            self?.characterIdsInSelectedLocation = self?.viewModel.filterCharacterIds(location: (self?.selectedLocation)!)
            print(self?.characterIdsInSelectedLocation)
            guard let characterIds = self?.characterIdsInSelectedLocation else { return }
            self?.viewModel.getCharactersByIds(ids: characterIds)
            self?.viewModel.successCallback = { [weak self] in
                print(self?.viewModel.characters?.first?.name)
                self?.characterCollectionView.reloadData()
                
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case locationCollectionView:
            return viewModel.location?.results?.count ?? 0
        case characterCollectionView:
            return viewModel.characters?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case locationCollectionView:
            let locationCollectionViewCell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
            locationCollectionViewCell.button.titleLabel?.text = viewModel.location?.results?[indexPath.row].name
            if viewModel.location?.results?[indexPath.row].name == "Earth (C-137)" {
                locationCollectionViewCell.button.backgroundColor = UIColor(named: "primary.500")
                locationCollectionViewCell.button.titleLabel?.textColor = UIColor(named: "gray.500")
            }
            return locationCollectionViewCell
        case characterCollectionView:
            let CharacterCollectionViewCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
            CharacterCollectionViewCell.character = viewModel.characters?[indexPath.row]
            CharacterCollectionViewCell.configure()
            return CharacterCollectionViewCell
        default:
            return UICollectionViewCell()
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2.05
        let height: CGFloat = width * (243 / 159.5)
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case locationCollectionView:
            selectedLocation = viewModel.location?.results?[indexPath.row]
            viewModel.characters?.removeAll()
            self.characterIdsInSelectedLocation = self.viewModel.filterCharacterIds(location: (self.selectedLocation)!)
            guard let characterIds = self.characterIdsInSelectedLocation else { return }
            self.viewModel.getCharactersByIds(ids: characterIds)
            self.viewModel.successCallback = { [weak self] in
                self?.characterCollectionView.reloadData()
            }
        case characterCollectionView:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController {
                //detailVC.character = viewModel.characters?[indexPath.row]
                //detailVC.configure()
                detailVC.modalPresentationStyle = .fullScreen
                present(detailVC, animated: true)
            }
        default:
            print("defaults")
            
        }
    }
}


