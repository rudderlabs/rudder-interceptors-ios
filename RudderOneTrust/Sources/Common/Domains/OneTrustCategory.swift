//
//  OneTrustCategory.swift
//  OneTrust
//
//  Created by Pallab Maiti on 20/01/23.
//

import Foundation

class OneTrustCategory: Codable {
    private let _optanonGroupId: String?
    var optanonGroupId: String {
        return _optanonGroupId ?? ""
    }
    
    private let _groupName: String?
    var groupName: String {
        return _groupName ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case _optanonGroupId = "OptanonGroupId"
        case _groupName = "GroupName"
    }
}

class OneTrustDomainGroupData: Codable {
    var groups: [OneTrustCategory]?
    
    enum CodingKeys: String, CodingKey {
        case groups = "Groups"
    }
}
