//
//  NetworkHeloer.swift
//  PortalGuide
//
//  Created by Batuhan on 27.03.2023.
//

import Foundation

enum ErrorTypes: String, Error {
    case invalidData = "Invalid data"
    case invalidUrl = "invalid url"
    case generalError = "An error happened"
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    var baseURL = "https://rickandmortyapi.com/api"
    
    func requestUrl(url: String) -> String {
        baseURL + url
    }
}
