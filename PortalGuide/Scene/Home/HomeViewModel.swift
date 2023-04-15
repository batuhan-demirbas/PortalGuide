//
//  HomeViewModel.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 27.03.2023.
//

import Foundation

class HomeViewModel {
    let manager = HomeManager.shared
    
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var selectedLocation: ResultElement?
    var location: Location?
    var locationArray: [ResultElement] = []
    var nextPage: Substring?
    
    var characters: [Character]?
    var characterIdsInSelectedLocation: [String]?
    var filteredCharacters: [Character]?
    
    var errorCallback: ((String)->())?
    var successCallback: (()->())?
    
    func getLocation(page: String) {
        manager.getLocation(page: page) { [weak self] location, error in
            guard let location = location else { return }
            if let error = error {
                self?.errorCallback?(error.localizedDescription)
            } else {
                if self?.selectedLocation == nil {
                    self?.selectedLocation = location.results.first
                }
                self?.locationArray.append(contentsOf: (location.results))
                self?.location = location
                self?.successCallback?()
                self?.nextPage = location.info?.next?.split(separator: "=").last
            }
            
        }
    }
    
    func getCharactersByIds(ids: [String]) {
        manager.getMultipleCharacters(ids: ids) { [weak self] characters, error in
            if let error = error {
                self?.errorCallback?(error.localizedDescription)
            } else {
                self?.characters = characters
                self?.filteredCharacters = characters
                self?.successCallback?()
            }
        }
    }
    
    func filterCharacterIds(location: ResultElement) {
        var ids: [String] = []
        location.residents?.forEach({ characterURL in
            let id = characterURL.split(separator: "/").last
            ids.append(String(id ?? "0"))
        })
        characterIdsInSelectedLocation = ids
    }
    
}
