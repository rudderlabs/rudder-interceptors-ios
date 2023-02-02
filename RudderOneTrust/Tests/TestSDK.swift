//
//  TestSDK.swift
//
//  Created by Pallab Maiti on 25/01/23.
//

import Foundation
#if os(tvOS)
@testable import RudderOneTrusttvOS
#else
@testable import RudderOneTrustiOS
#endif


class TestSDK: OneTrustSDK {
    let domainData: [String: Any] = [
        "Groups": [
            [
                "CustomGroupId": "CAT01",
                "GroupName": "Strictly Necessary Cookies"
            ],
            [
                "CustomGroupId": "CAT02",
                "GroupName": "Category 2"
            ],
            [
                "CustomGroupId": "CAT03",
                "GroupName": "Category 3"
            ],
            [
                "CustomGroupId": "CAT04",
                "GroupName": "Category 4"
            ]
        ]
    ]
    
    var categoryList: [OneTrustCategory]? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: domainData), let result = try? JSONDecoder().decode(OneTrustDomainGroupData.self, from: jsonData) {
            return result.groups
        }
        return nil
    }
    
    func fetchCategoryList() -> [OneTrustCategory]? {
        return categoryList
    }
    
    func getConsentStatus(forCategoryId: String) -> Bool {
        guard let categoryList = categoryList, !categoryList.isEmpty else {
            return false
        }
        let category = categoryList.first { category in
            return category.optanonGroupId == forCategoryId
        }
        switch category?.optanonGroupId {
            case "CAT01":
                return true
            case "CAT02":
                return false
            case "CAT03":
                return true
            case "CAT04":
                return true
            default:
                return false
        }
    }
}
