//
//  LocationManager.swift
//  PortalGuide
//
//  Created by Batuhan on 27.03.2023.
//

import Foundation

protocol HomeManagerProtocol {
    func getLocation(complete: @escaping((Location?, Error?)->()))
}

class HomeManager: HomeManagerProtocol {
    static let shared = HomeManager()
    
    func getLocation(complete: @escaping((Location?, Error?)->())) {
        NetworkManager.shared.request(type: Location.self, url: HomeEndpoint.location.path, method: .get) { response in
            switch response {
            case .success(let data):
                complete(data, nil)
            case.failure(let error):
                complete(nil, error)
            }
        }
    }
    
    func getMultipleCharacters(ids: [String], complete: @escaping(([Character]?, Error?)->())) {
        let joinedIds = ids.joined(separator: ",")
        NetworkManager.shared.request(type: [Character].self, url: HomeEndpoint.character.path + "/\(joinedIds)", method: .get) { response in
            switch response {
            case .success(let data):
                complete(data, nil)
            case.failure(let error):
                complete(nil, error)
            }
        }
    }
}
