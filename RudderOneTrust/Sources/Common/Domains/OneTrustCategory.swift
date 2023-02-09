//
//  OneTrustCategory.swift
//  RudderOneTrust
//
//  Created by Pallab Maiti on 20/01/23.
//

import Foundation

class OneTrustCategory: Codable {
    private let _customGroupId: String?
    var customGroupId: String {
        return _customGroupId ?? ""
    }
    
    private let _groupName: String?
    var groupName: String {
        return _groupName ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case _customGroupId = "CustomGroupId"
        case _groupName = "GroupName"
    }
}

class OneTrustDomainGroupData: Codable {
    var groups: [OneTrustCategory]?
    
    enum CodingKeys: String, CodingKey {
        case groups = "Groups"
    }
}
