//
//  OneTrustCookieCategory.swift
//  OneTrust
//
//  Created by Pallab Maiti on 20/01/23.
//


import Rudder

class DestinationConfig: Codable {
    class OneTrustCookieCategory: Codable {
        private let _oneTrustCookieCategory: String?
        var oneTrustCookieCategory: String {
            return _oneTrustCookieCategory ?? ""
        }
        
        enum CodingKeys: String, CodingKey {
            case _oneTrustCookieCategory = "oneTrustCookieCategory"
        }
    }
    
    private let _oneTrustCookieCategories: [OneTrustCookieCategory]?
    var oneTrustCookieCategories: [String]? {
        return _oneTrustCookieCategories?.filter({ oneTrustCookieCategory in
            return !oneTrustCookieCategory.oneTrustCookieCategory.isEmpty
        }).compactMap({ oneTrustCookieCategory in
            return oneTrustCookieCategory.oneTrustCookieCategory
        })
    }
    
    enum CodingKeys: String, CodingKey {
        case _oneTrustCookieCategories = "oneTrustCookieCategories"
    }
}
