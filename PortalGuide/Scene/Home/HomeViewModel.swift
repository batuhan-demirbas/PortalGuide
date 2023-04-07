//
//  HomeViewModel.swift
//  PortalGuide
//
//  Created by Batuhan on 27.03.2023.
//

import Foundation

class HomeViewModel {
    let manager = HomeManager.shared
    
    var location: Location?
    var locationArray: [ResultElement] = []
    var characters: [Character]?
    var errorCallback: ((String)->())?
    var successCallback: (()->())?
    
    func getLocation(page: String) {
        manager.getLocation(page: page) { [weak self] location, error in
            guard let location = location else { return }
            if let error = error {
                self?.errorCallback?(error.localizedDescription)
            } else {
                self?.locationArray.append(contentsOf: (location.results))
                self?.location = location
                self?.successCallback?()
            }
            
        }
    }
    
    func getCharactersByIds(ids: [String]) {
        manager.getMultipleCharacters(ids: ids) { [weak self] characters, error in
            if let error = error {
                self?.errorCallback?(error.localizedDescription)
            } else {
                self?.characters = characters
                self?.successCallback?()
            }
        }
    }
    
    func filterCharacterIds(location: ResultElement) -> [String] {
        var ids: [String] = []
        location.residents?.forEach({ characterURL in
            let id = characterURL.split(separator: "/").last
            ids.append(String(id ?? "0"))
        })
        return ids
    }
    
}
