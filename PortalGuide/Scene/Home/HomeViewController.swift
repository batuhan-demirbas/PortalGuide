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
    private var selectedIndexPath: IndexPath?
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndexPath = IndexPath(row: 0, section: 0)
        
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
            locationCollectionViewCell.label.text = viewModel.location?.results?[indexPath.row].name
            if viewModel.location?.results?[indexPath.row].name == "Earth (C-137)" {
                locationCollectionViewCell.backgroundColor = UIColor(named: "primary.500")
                locationCollectionViewCell.label.textColor = UIColor(named: "gray.500")
            } else {
                locationCollectionViewCell.backgroundColor = .clear
                locationCollectionViewCell.label.textColor = UIColor(named: "white")
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
        selectedIndexPath = indexPath
        collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let locationCell = cell as? LocationCollectionViewCell {
            // Her hücrenin varsayılan rengi ve görünümü belirlenir
            if let location = viewModel.location?.results?[indexPath.row] {
                if indexPath == selectedIndexPath {
                    // Seçili hücrenin rengini değiştirin
                    locationCell.backgroundColor = UIColor(named: "primary.500")
                    locationCell.label.textColor = UIColor(named: "gray.500")
                } else {
                    // Diğer hücrelerin rengini varsayılan hâline getirin
                    locationCell.backgroundColor = .clear
                    locationCell.label.textColor = .white
                }
            }
        }
    }
    
}


