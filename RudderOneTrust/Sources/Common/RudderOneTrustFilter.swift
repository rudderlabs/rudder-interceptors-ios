//
//  RudderOneTrustFilter.swift
//  OneTrust
//
//  Created by Pallab Maiti on 17/01/23.
//

import Foundation
import Rudder

protocol OneTrustSDK {
    func fetchCategoryList() -> [OneTrustCategory]?
    
    func getConsentStatus(forCategoryId: String) -> Bool
}

@objc
open class RudderOneTrustConsentFilter: NSObject, RSConsentFilter {
    private var oneTrustSDK: OneTrustSDK!
    
    @objc
    public override init() {
        super.init()
#if os(tvOS)
        oneTrustSDK = tvOSSDK()
#else
        oneTrustSDK = iOSSDK()
#endif
    }
    
    init(oneTrustSDK: OneTrustSDK) {
        self.oneTrustSDK = oneTrustSDK
    }
    
    public func filterConsentedDestinations(_ destinations: [RSServerDestination]) -> [String: NSNumber]? {
        guard let oneTrustCategoryList = oneTrustSDK.fetchCategoryList(), !oneTrustCategoryList.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptorModel: no OneTrustCookieCategories found from OneTrust SDK")
            return nil
        }
        
        var integrations = [String: NSNumber]()
        for destination in destinations {
            let integration = getIntegration(from: destination, with: oneTrustCategoryList)
            integrations.merge(integration) { (_, new) in new }
        }
        return !integrations.isEmpty ? integrations : nil
    }
}

extension RudderOneTrustConsentFilter {
    func getIntegration(from destination: RSServerDestination, with oneTrustCategoryList: [OneTrustCategory]) -> [String: NSNumber] {
        guard let rudderOneTrustCategoryList = getRudderOneTrustCategoryList(destination: destination), !rudderOneTrustCategoryList.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptorModel: no OneTrustCookieCategories found from Config BE for \(destination.destinationName)")
            return [destination.destinationDefinition.displayName: NSNumber(booleanLiteral: true)]
        }
        var isEnabled = false
        var integration = [String: NSNumber]()
        for oneTrustCookieCategory in rudderOneTrustCategoryList {
            if let group = oneTrustCategoryList.first(where: { oneTrustGroup in
                return (oneTrustGroup.customGroupId == oneTrustCookieCategory || oneTrustGroup.groupName == oneTrustCookieCategory)
            }) {
                isEnabled = oneTrustSDK.getConsentStatus(forCategoryId: group.customGroupId)
                /// if `isEnabled` is become false, exist from the loop.
                /// if any consent status is false, the integration will be false.
                if !isEnabled {
                    break
                }
            }
        }
        integration[destination.destinationDefinition.displayName] = NSNumber(booleanLiteral: isEnabled)
        return integration
    }
    
    func getRudderOneTrustCategoryList(destination: RSServerDestination) -> [String]? {
        guard let destinationConfig = getDestinationConfig(destination: destination), let oneTrustCookieCategories = destinationConfig.oneTrustCookieCategories, !oneTrustCookieCategories.isEmpty else {
            return nil
        }
        return oneTrustCookieCategories
    }
    
    func getDestinationConfig(destination: RSServerDestination) -> DestinationConfig? {
        if let config: [String: Any] = destination.destinationConfig as? [String: Any] {
            if let jsonData = try? JSONSerialization.data(withJSONObject: config) {
                return try? JSONDecoder().decode(DestinationConfig.self, from: jsonData)
            }
        }
        return nil
    }
}

