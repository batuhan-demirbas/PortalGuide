//
//  Character.swift
//  PortalGuide
//
//  Created by Batuhan on 27.03.2023.
//

import Foundation

// MARK: - Character
struct Character: Codable {
    let id: Int?
    let name, status, species, type: String?
    let gender: String?
    let origin, location: Station?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

// MARK: - Station
struct Station: Codable {
    let name: String?
    let url: String?
}
