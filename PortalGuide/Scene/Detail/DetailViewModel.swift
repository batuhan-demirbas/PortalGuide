//
//  DetailViewModel.swift
//  PortalGuide
//
//  Created by Batuhan on 5.04.2023.
//

import Foundation

class DetailViewModel {
    let manager = HomeManager.shared
    
    var location: Location?
    var characters: [Character]?
    var errorCallback: ((String)->())?
    var successCallback: (()->())?
    
    func getLocation() {
        manager.getLocation { [weak self] location, error in
            if let error = error {
                self?.errorCallback?(error.localizedDescription)
            } else {
                self?.location = location
                self?.successCallback?()
            }
            
        }
    }
    
    func filterEpisodeURLs(episodeURLs: [String]) -> [String] {
        var episodes: [String] = []
        episodeURLs.forEach({ episodeURL in
            let id = episodeURL.split(separator: "/").last
            episodes.append(String(id ?? "0"))
        })
        return episodes
    }
    
}

