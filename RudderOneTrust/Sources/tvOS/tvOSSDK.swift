//
//  OTtvOSModel.swift
//  OneTrust-tvOS
//
//  Created by Pallab Maiti on 20/01/23.
//

import Foundation
import OTPublishersHeadlessSDKtvOS

class tvOSSDK: OneTrustSDK {
    func fetchCategoryList() -> [OneTrustCategory]? {
        if let domainData = OTPublishersHeadlessSDK.shared.getDomainGroupData(),
           let jsonData = try? JSONSerialization.data(withJSONObject: domainData),
           let result = try? JSONDecoder().decode(OneTrustDomainGroupData.self, from: jsonData) {
            return result.groups
        }
        return nil
    }
    
    func getConsentStatus(forCategoryId: String) -> Bool {
        return (OTPublishersHeadlessSDK.shared.getConsentStatus(forCategory: forCategoryId) == 0) ? false : true
    }
}
