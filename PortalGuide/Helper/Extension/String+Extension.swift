//
//  String+Extension.swift
//  PortalGuide
//
//  Created by Batuhan Demirbaş on 7.04.2023.
//

import Foundation

extension String {
    func convertToCustomDateFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd MMM yyyy, HH:mm:ss"
            let convertedDate = dateFormatter.string(from: date)
            return convertedDate
        } else {
            return nil
        }
    }
}
