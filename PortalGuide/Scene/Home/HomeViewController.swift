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
    
    private var selectedLocation: ResultElement?
    private var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private var characterIdsInSelectedLocation: [String]?
    var filteredCharacters: [Character]?
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMessageLabel()
        
        searchTextField.delegate = self
        
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        
        viewModelConfiguration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateMessageLabel() {
        if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
            messageLabel.text = "Hi,"
        }
        else {
            messageLabel.text = "Welcome,"
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
        }
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
                self?.filteredCharacters = self?.viewModel.characters
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
            return filteredCharacters?.count ?? 0
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
            CharacterCollectionViewCell.character = filteredCharacters?[indexPath.row]
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
            filteredCharacters?.removeAll()
            self.characterIdsInSelectedLocation = self.viewModel.filterCharacterIds(location: (self.selectedLocation)!)
            guard let characterIds = self.characterIdsInSelectedLocation else { return }
            self.viewModel.getCharactersByIds(ids: characterIds)
            self.viewModel.successCallback = { [weak self] in
                if self?.searchTextField.text != "" {
                    self?.filterCharacter()
                } else {
                    self?.filteredCharacters = self?.viewModel.characters

                }
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
            if (viewModel.location?.results?[indexPath.row]) != nil {
                if indexPath == selectedIndexPath {
                    locationCell.backgroundColor = UIColor(named: "primary.500")
                    locationCell.label.textColor = UIColor(named: "gray.500")
                } else {
                    locationCell.backgroundColor = .clear
                    locationCell.label.textColor = .white
                }
            }
        }
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    
    func filterCharacter() {
        filteredCharacters = []
        
        guard let searchText = searchTextField.text else { return }
        
        filteredCharacters = viewModel.characters?.filter({ $0.name?.lowercased().contains(searchText.lowercased()) == true }) ?? []
        
        characterCollectionView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        filteredCharacters = []
        
        let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        if searchText == "" {
            filteredCharacters = viewModel.characters ?? []
        } else {
            
            filteredCharacters = viewModel.characters?.filter({ $0.name?.lowercased().contains(searchText.lowercased()) == true }) ?? []
        }
        
        characterCollectionView.reloadData()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // TextField temizlendiğinde çalışır
        
        // Orijinal veriyi filtrelenmiş veriye kopyala
        filteredCharacters = viewModel.characters
        
        // CollectionView'da güncel veriyi yeniden yükle
        characterCollectionView.reloadData()
        
        return true
    }
}
