//
//  DetailViewModel.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 5.04.2023.
//

import Foundation

class DetailViewModel {
    
    func filterEpisodeURLs(episodeURLs: [String]) -> [String] {
        var episodes: [String] = []
        episodeURLs.forEach({ episodeURL in
            let id = episodeURL.split(separator: "/").last
            episodes.append(String(id ?? "0"))
        })
        return episodes
    }
    
}

