//
//  OTtvOSModel.swift
//  OneTrust-tvOS
//
//  Created by Pallab Maiti on 20/01/23.
//

import Foundation
import OTPublishersHeadlessSDKtvOS

class tvOSSDK: OneTrustSDK {
    func getDomainGroupData() -> [String: Any]? {
        return OTPublishersHeadlessSDK.shared.getDomainGroupData()
    }
    
    func getConsentStatus(forCategoryId: String) -> Bool {
        return (OTPublishersHeadlessSDK.shared.getConsentStatus(forCategory: forCategoryId) == 1)
    }
}
