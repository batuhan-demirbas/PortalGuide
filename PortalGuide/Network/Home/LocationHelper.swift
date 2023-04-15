//
//  LocationHelper.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 27.03.2023.
//

enum HomeEndpoint: String {
    case location = "/location"
    case character = "/character"
    
    var path: String {
        switch self {
        case .location:
            return NetworkHelper.shared.requestUrl(url: HomeEndpoint.location.rawValue)
        case .character:
            return NetworkHelper.shared.requestUrl(url: HomeEndpoint.character.rawValue)
        }
    }
}

