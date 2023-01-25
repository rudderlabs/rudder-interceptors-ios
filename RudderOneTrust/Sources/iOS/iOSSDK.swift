//
//  OTiOSModel.swift
//  OneTrust-iOS
//
//  Created by Pallab Maiti on 20/01/23.
//

import Foundation
import OTPublishersHeadlessSDK

class iOSSDK: OneTrustSDK {    
    func getDomainGroupData() -> [String: Any]? {
        return OTPublishersHeadlessSDK.shared.getDomainGroupData()
    }
    
    func getConsentStatus(forCategoryId: String) -> Bool {
        return (OTPublishersHeadlessSDK.shared.getConsentStatus(forCategory: forCategoryId) == 1)
    }
}
