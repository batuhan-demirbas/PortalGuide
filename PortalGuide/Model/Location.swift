//
//  Location.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 27.03.2023.
//

import Foundation

// MARK: - Location
struct Location: Codable {
    let info: Info?
    let results: [ResultElement]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int?
    let next, prev: String?
}

// MARK: - Result
struct ResultElement: Codable {
    let id: Int?
    let name, type, dimension: String?
    let residents: [String]?
    let url: String?
    let created: String?
}
