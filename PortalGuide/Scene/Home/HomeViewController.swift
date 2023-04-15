//
//  ViewController.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 27.03.2023.
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
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAspectRatioForHeader()
        hideKeyboardWhenTappedAround()
        searchTextField.delegate = self
        
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterLandscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterLandscapeCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "SkeletonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkeletonCollectionViewCell")
        
        viewModelConfiguration()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAspectRatioForHeader()
    }
    
    func updateAspectRatioForHeader() {
        let aspectRatioMultiplier: CGFloat = UIApplication.shared.statusBarOrientation.isLandscape ? 812/226 : 375/257
        
        let aspectRatioConstraint = NSLayoutConstraint(item: headarView, attribute: .width, relatedBy: .equal, toItem: headarView, attribute: .height, multiplier: aspectRatioMultiplier, constant: 0)
        NSLayoutConstraint.activate([aspectRatioConstraint])
        characterCollectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    fileprivate func viewModelConfiguration() {
        viewModel.getLocation(page: "1")
        viewModel.errorCallback = { [weak self] errorMessage in
            print("error: \(errorMessage)")
        }
        viewModel.successCallback = { [weak self] in
            self?.locationCollectionView.reloadData()
            self?.viewModel.filterCharacterIds(location: (self?.viewModel.selectedLocation)!)
            guard let characterIds = self?.viewModel.characterIdsInSelectedLocation else { return }
            self?.viewModel.getCharactersByIds(ids: characterIds)
            self?.viewModel.successCallback = { [weak self] in
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
            return updateAlertStackView(with: viewModel)
        default:
            return 0
        }
    }
    
    func updateAlertStackView(with viewModel: HomeViewModel) -> Int {
        if let characterIds = viewModel.characterIdsInSelectedLocation, characterIds.isEmpty {
            showAlert(with: "noalien")
            return 0
        } else if viewModel.filteredCharacters?.count == 0 {
            showAlert(with: "nofound")
        } else {
            alertStackView.isHidden = true
        }
        return viewModel.filteredCharacters?.count ?? 6
    }
    
    func showAlert(with imageName: String) {
        alertStackView.isHidden = false
        alertImageView.image = UIImage(named: imageName)
        alertLabel.text = imageName == "noalien" ? "no signs of life found" : "character not found"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case locationCollectionView:
            let locationCollectionViewCell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
            locationCollectionViewCell.label.text = viewModel.locationArray[indexPath.row].name
            if viewModel.locationArray[indexPath.row].name == "Earth (C-137)" {
                locationCollectionViewCell.backgroundColor = .primary
                locationCollectionViewCell.label.textColor = .Grey.dark
            } else {
                locationCollectionViewCell.backgroundColor = .clear
                locationCollectionViewCell.label.textColor = .white
            }
            return locationCollectionViewCell
        case characterCollectionView:
            if viewModel.filteredCharacters == nil {
                let skeletonCollectionViewCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonCollectionViewCell", for: indexPath) as! SkeletonCollectionViewCell
                return skeletonCollectionViewCell
            } else {
                if UIApplication.shared.statusBarOrientation.isLandscape {
                    let CharacterLandscapeCollectionViewCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterLandscapeCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
                    CharacterLandscapeCollectionViewCell.character = viewModel.filteredCharacters?[indexPath.row]
                    CharacterLandscapeCollectionViewCell.configure()
                    return CharacterLandscapeCollectionViewCell
                    
                } else {
                    let CharacterCollectionViewCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
                    CharacterCollectionViewCell.character = viewModel.filteredCharacters?[indexPath.row]
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
        let isLandscape = UIApplication.shared.statusBarOrientation.isLandscape
        let width = (collectionView.frame.width - 48) / 2.05
        let height = isLandscape ? width * (117 / 367) : width * (243 / 159.5)
        return CGSize(width: width, height: height)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        alertStackView.isHidden = true
        viewModel.selectedIndexPath = indexPath
        collectionView.reloadData()
        switch collectionView {
        case locationCollectionView:
            if characterCollectionView.numberOfItems(inSection: 0) > 0 {
                let topIndexPath = IndexPath(item: 0, section: 0)
                characterCollectionView.scrollToItem(at: topIndexPath, at: .top, animated: true)
            }
            viewModel.selectedLocation = viewModel.locationArray[indexPath.row]
            viewModel.filteredCharacters = nil
            characterCollectionView.reloadData()
            self.viewModel.filterCharacterIds(location: (viewModel.selectedLocation)!)
            guard let characterIds = viewModel.characterIdsInSelectedLocation else { return }
            self.viewModel.getCharactersByIds(ids: characterIds)
            self.viewModel.successCallback = { [weak self] in
                if self?.searchTextField.text != "" {
                    self?.filterCharacter()
                } else {
                    self?.viewModel.filteredCharacters = self?.viewModel.characters
                    
                }
                self?.characterCollectionView.reloadData()
            }
        case characterCollectionView:
            guard let character = viewModel.filteredCharacters?[indexPath.row] else { return }
            let sender: Character = character
            performSegue(withIdentifier: "showDetail", sender: sender)
            
        default:
            print("defaults")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let locationCell = cell as? LocationCollectionViewCell {
            if (viewModel.locationArray[indexPath.row]) != nil {
                if indexPath == viewModel.selectedIndexPath {
                    locationCell.backgroundColor = .primary
                    locationCell.label.textColor = .Grey.dark
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
        viewModel.filteredCharacters = []
        guard let searchText = searchTextField.text else { return }
        viewModel.filteredCharacters = viewModel.characters?.filter({ $0.name?.lowercased().contains(searchText.lowercased()) == true }) ?? []
        characterCollectionView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel.filteredCharacters = []
        let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        if searchText == "" {
            viewModel.filteredCharacters = viewModel.characters ?? []
        } else {
            viewModel.filteredCharacters = viewModel.characters?.filter({ $0.name?.lowercased().contains(searchText.lowercased()) == true }) ?? []
        }
        characterCollectionView.reloadData()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.filteredCharacters = viewModel.characters
        characterCollectionView.reloadData()
        return true
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == locationCollectionView {
            let contentOffsetX = scrollView.contentOffset.x
            let maximumOffsetX = scrollView.contentSize.width - scrollView.frame.width
            
            let threshold: CGFloat = 10.0
            if contentOffsetX + threshold >= maximumOffsetX {
                if viewModel.location?.info?.next != nil && "1" != viewModel.nextPage  {
                    loadMoreData()
                }
            }
        }
    }
    
    func loadMoreData() {
        viewModel.getLocation(page: String(viewModel.nextPage ?? "1"))
        viewModel.errorCallback = { [weak self] errorMessage in
            print("error: \(errorMessage)")
        }
        viewModel.successCallback = { [weak self] in
            self?.locationCollectionView.reloadData()
        }
    }
    
}
