//
//  OneTrustCookieCategory.swift
//  RudderOneTrust
//
//  Created by Pallab Maiti on 25/01/23.
//

import Foundation
import Rudder

protocol CookieCategory {
    var destination: RSServerDestination! { get set }
    func getRudderOneTrustCookieCategories() -> [String]?
}

class OneTrustCookieCategory: CookieCategory {
    var destination: RSServerDestination!
    
    init(destination: RSServerDestination) {
        self.destination = destination
    }
    
    func getRudderOneTrustCookieCategories() -> [String]? {
        guard let destinationConfig = getDestinationConfig(), let oneTrustCookieCategories = destinationConfig.oneTrustCookieCategories, !oneTrustCookieCategories.isEmpty else {
            return nil
        }
        return oneTrustCookieCategories
    }
    
    func getDestinationConfig() -> DestinationConfig? {
        if let config: [String: Any] = destination?.destinationConfig as? [String: Any] {
            if let jsonData = try? JSONSerialization.data(withJSONObject: config) {
                return try? JSONDecoder().decode(DestinationConfig.self, from: jsonData)
            }
        }
        return nil
    }
}
