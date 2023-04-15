//
//  Character.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 27.03.2023.
//

import Foundation

// MARK: - Character
struct Character: Codable {
    let id: Int?
    let name, status, species, type: String?
    let gender: String?
    let origin, location: Station?
    let image: String?
    let episode: [String]
    let url: String?
    let created: String?
}

// MARK: - Station
struct Station: Codable {
    let name: String?
    let url: String?
}

enum Gender: String {
    case male
    case female
    case unknown
    
    var icon: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        case .unknown:
            return "unknown"
        }
    }
}

enum Status: String {
    case alive
    case dead
    case unknown
    
    var color: String {
        switch self {
        case .alive:
            return "status.green"
        case .dead:
            return "status.red"
        case .unknown:
            return "status.orange"
        }
    }
}
