//
//  TestSDK.swift
//  RudderOneTrust
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
                "OptanonGroupId": "CAT01",
                "GroupName": "Strictly Necessary Cookies"
            ],
            [
                "OptanonGroupId": "CAT02",
                "GroupName": "Category 2"
            ],
            [
                "OptanonGroupId": "CAT03",
                "GroupName": "Category 3"
            ],
            [
                "OptanonGroupId": "CAT04",
                "GroupName": "Category 4"
            ]
        ]
    ]
    
    func getDomainGroupData() -> [String: Any]? {
        return domainData
    }
    
    func getConsentStatus(forCategoryId: String) -> Bool {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: domainData), let result = try? JSONDecoder().decode(OneTrustDomainGroupData.self, from: jsonData), let groupList = result.groups, !groupList.isEmpty else {
            return false
        }
        for list in groupList {
            switch list.optanonGroupId {
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
        return false
    }
}
