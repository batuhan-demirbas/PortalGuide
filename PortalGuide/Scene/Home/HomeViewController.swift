//
//  ViewController.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 27.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headarView: UIView!
    @IBOutlet weak var searchDescriptionLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBOutlet weak var alertStackView: UIStackView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    
    let viewModel = HomeViewModel()
    var homeData: HomeData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        searchTextField.delegate = self
        
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "CharacterLandscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterLandscapeCollectionViewCell")
        characterCollectionView.register(UINib(nibName: "SkeletonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkeletonCollectionViewCell")
        
        
        if let homeData = homeData {
            updateData(with: homeData)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAspectRatioForHeader()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAspectRatioForHeader()
    }
    
    func updateData(with data: HomeData) {
        viewModel.location = data.location
        viewModel.locationArray.append(contentsOf: (data.location.results))
        viewModel.characters = data.characters
        viewModel.nextPage = data.location.info?.next?.split(separator: "=").last
        viewModel.filteredCharacters = data.characters
        characterCollectionView.reloadData()
        locationCollectionView.reloadData()
    }
    
    func updateAspectRatioForHeader() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let screenRatio = UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width
        searchDescriptionLabel.isHidden = (screenRatio < 1) && (screenRatio > 0.50)
        
        let aspectRatioMultiplier: CGFloat = windowScene.interfaceOrientation.isLandscape ? 812.0 / 226.0 : 375.0 / 257.0
        
        let aspectRatioConstraint = NSLayoutConstraint(item: headarView as Any, attribute: .width, relatedBy: .equal, toItem: headarView, attribute: .height, multiplier: aspectRatioMultiplier, constant: 0)
        NSLayoutConstraint.activate([aspectRatioConstraint])
        
        characterCollectionView.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
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
            let count = viewModel.locationArray.count
            return viewModel.isLoading ? count + 1 : count
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
            let locationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
            
            if viewModel.isLoading  && indexPath.item == viewModel.locationArray.count {
                locationCell.indicator.isHidden = false
                locationCell.label.isHidden = true
            } else {
                locationCell.indicator.isHidden = true
                locationCell.label.isHidden = false
                locationCell.label.text = viewModel.locationArray[indexPath.row].name
                
            }
            
            return locationCell
            
        case characterCollectionView:
            let characterCell = characterCVConfigure(cellForItemAt: indexPath)
            return characterCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func characterCVConfigure(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.filteredCharacters == nil {
            let skeletonCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonCollectionViewCell", for: indexPath) as! SkeletonCollectionViewCell
            return skeletonCell
            
        } else {
            let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
            if windowScene.isLandscape {
                let CharacterLandscapeCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterLandscapeCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
                CharacterLandscapeCell.character = viewModel.filteredCharacters?[indexPath.row]
                
                CharacterLandscapeCell.configure()
                return CharacterLandscapeCell
                
            } else {
                let CharacterCell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
                CharacterCell.character = viewModel.filteredCharacters?[indexPath.row]
                CharacterCell.configure()
                return CharacterCell
            }
            
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let width = (collectionView.frame.width - 48) / 2.06
        let height = windowScene.isLandscape ? width * (117 / 367) : width * (243 / 159.5)
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
            fetchCharacterWhenLocationSelect(didSelectItemAt: indexPath)
            
        case characterCollectionView:
            guard let character = viewModel.filteredCharacters?[indexPath.row] else { return }
            let sender: Character = character
            performSegue(withIdentifier: "showDetail", sender: sender)
            
        default:
            print("defaults")
        }
        
    }
    
    func fetchCharacterWhenLocationSelect(didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedLocation = viewModel.locationArray[indexPath.row]
        viewModel.filteredCharacters = nil
        self.viewModel.filterCharacterIds(location: (viewModel.selectedLocation)!)
        guard let characterIds = viewModel.characterIdsInSelectedLocation else { return }
        characterCollectionView.reloadData()
        
        self.viewModel.getCharactersByIds(ids: characterIds)
        self.viewModel.successCallback = { [weak self] in
            guard let searchText = self?.searchTextField.text else { return }
            self?.viewModel.filterCharacter(searchText: searchText)
            self?.characterCollectionView.reloadData()
            self?.characterCollectionView.scrollTop()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let locationCell = cell as? LocationCollectionViewCell {
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

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            viewModel.filterCharacter(searchText: searchText)
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
                    !viewModel.isLoading ? loadMoreLocationData() : nil
                }
            }
        }
    }
    
    func loadMoreLocationData() {
        viewModel.isLoading = true
        locationCollectionView.reloadData()
        viewModel.getLocation(page: String(viewModel.nextPage ?? "1"))
        viewModel.errorCallback = {errorMessage in
            print("error: \(errorMessage)")
            self.viewModel.isLoading = false
        }
        viewModel.successCallback = { [weak self] in
            self?.locationCollectionView.reloadData()
            self?.viewModel.isLoading = false
            
        }
    }
    
}
