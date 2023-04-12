//
//  ViewController.swift
//  PortalGuide
//
//  Created by Batuhan on 27.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headarView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBOutlet weak var alertStackView: UIStackView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    
    var selectedLocation: ResultElement?
    private var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var characterIdsInSelectedLocation: [String]?
    var filteredCharacters: [Character]?
    let viewModel = HomeViewModel()
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMessageLabel()
        
        searchTextField.delegate = self
        
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterLandscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterLandscapeCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "SkeletonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkeletonCollectionViewCell")
        
        viewModelConfiguration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        characterCollectionView.reloadData()
        if UIDevice.current.orientation.isLandscape {
            let aspectRatioConstraint = NSLayoutConstraint(item: headarView, attribute: .width, relatedBy: .equal, toItem: headarView, attribute: .height, multiplier: 812/226, constant: 0)
            NSLayoutConstraint.activate([aspectRatioConstraint])
        } else {
            let aspectRatioConstraint = NSLayoutConstraint(item: headarView, attribute: .width, relatedBy: .equal, toItem: headarView, attribute: .height, multiplier: 375/257, constant: 0)
            NSLayoutConstraint.activate([aspectRatioConstraint])
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        viewModel.getLocation(page: "1")
        viewModel.errorCallback = { [weak self] errorMessage in
            print("error: \(errorMessage)")
        }
        viewModel.successCallback = { [weak self] in
            self?.locationCollectionView.reloadData()
            if self?.selectedLocation == nil {
                self?.selectedLocation = self?.viewModel.location?.results.first
            }
            self?.characterIdsInSelectedLocation = self?.viewModel.filterCharacterIds(location: (self?.selectedLocation)!)
            guard let characterIds = self?.characterIdsInSelectedLocation else { return }
            self?.viewModel.getCharactersByIds(ids: characterIds)
            self?.viewModel.successCallback = { [weak self] in
                self?.filteredCharacters = self?.viewModel.characters
                self?.characterCollectionView.reloadData()
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            let detailVC = segue.destination as! DetailViewController
            let object = sender as! Character
            detailVC.character = object
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case locationCollectionView:
            return viewModel.locationArray.count
        case characterCollectionView:
            if let characterIds = self.characterIdsInSelectedLocation {
                if characterIds.isEmpty {
                    alertStackView.isHidden = false
                    alertImageView.image = UIImage(named: "noalien")
                    alertLabel.text = "no signs of life found"
                    return 0
                }
            }
            if filteredCharacters?.count == 0 {
                alertStackView.isHidden = false
                alertImageView.image = UIImage(named: "nofound")
                alertLabel.text = "character not found"
                
            } else {
                alertStackView.isHidden = true
                
            }
            return filteredCharacters?.count ?? 6
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case locationCollectionView:
            let locationCollectionViewCell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
            locationCollectionViewCell.label.text = viewModel.locationArray[indexPath.row].name
            if viewModel.locationArray[indexPath.row].name == "Earth (C-137)" {
                locationCollectionViewCell.backgroundColor = UIColor(named: "primary.500")
                locationCollectionViewCell.label.textColor = UIColor(named: "gray.500")
            } else {
                locationCollectionViewCell.backgroundColor = .clear
                locationCollectionViewCell.label.textColor = UIColor(named: "white")
            }
            return locationCollectionViewCell
        case characterCollectionView:
            if filteredCharacters == nil {
                let skeletonCollectionViewCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonCollectionViewCell", for: indexPath) as! SkeletonCollectionViewCell
                return skeletonCollectionViewCell
            } else {
                if UIDevice.current.orientation.isLandscape {
                    let CharacterLandscapeCollectionViewCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterLandscapeCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
                    CharacterLandscapeCollectionViewCell.character = filteredCharacters?[indexPath.row]
                    CharacterLandscapeCollectionViewCell.configure()
                    return CharacterLandscapeCollectionViewCell
                    
                } else {
                    let CharacterCollectionViewCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
                    CharacterCollectionViewCell.character = filteredCharacters?[indexPath.row]
                    CharacterCollectionViewCell.configure()
                    return CharacterCollectionViewCell
                }
                
            }
        default:
            return UICollectionViewCell()
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            let width = (collectionView.frame.width - 48) / 2.1
            let height: CGFloat = width * (117 / 367)
            return CGSize(width: width, height: height)
            
        } else {
            let width = (collectionView.frame.width - 48) / 2.1
            let height: CGFloat = width * (243 / 159.5)
            return CGSize(width: width, height: height)
        }
        
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        alertStackView.isHidden = true
        selectedIndexPath = indexPath
        collectionView.reloadData()
        switch collectionView {
        case locationCollectionView:
            //characterCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            selectedLocation = viewModel.locationArray[indexPath.row]
            filteredCharacters = nil
            characterCollectionView.reloadData()
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
            guard let character = filteredCharacters?[indexPath.row] else { return }
            let sender: Character = character
            performSegue(withIdentifier: "showDetail", sender: sender)
            
        default:
            print("defaults")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let locationCell = cell as? LocationCollectionViewCell {
            if (viewModel.locationArray[indexPath.row]) != nil {
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
        filteredCharacters = viewModel.characters
        
        characterCollectionView.reloadData()
        
        return true
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == locationCollectionView {
            let contentOffsetX = scrollView.contentOffset.x
            let maximumOffsetX = scrollView.contentSize.width - scrollView.frame.width
            
            guard let nextPage = viewModel.location?.info?.next?.split(separator: "=").last else { return }
            
            let threshold: CGFloat = 10.0 // Eşik değeri
            
            if contentOffsetX + threshold >= maximumOffsetX {
                if viewModel.location?.info?.next != nil && page != Int(nextPage)  {
                    loadMoreData()
                    page += 1
                }
            }
        }
    }
    
    func loadMoreData() {
        let nextPage = viewModel.location?.info?.next?.split(separator: "=").last
        viewModel.getLocation(page: String(nextPage ?? "1"))
        viewModel.errorCallback = { [weak self] errorMessage in
            print("error: \(errorMessage)")
        }
        viewModel.successCallback = { [weak self] in
            self?.locationCollectionView.reloadData()
        }
        
    }
}
