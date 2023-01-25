//
//  OneTrustInterceptorModel.swift
//  OneTrust
//
//  Created by Pallab Maiti on 20/01/23.
//

import Foundation
import Rudder

protocol OneTrustSDK {
    func getDomainGroupData() -> [String: Any]?
    
    func getConsentStatus(forCategoryId: String) -> Bool
}

class OneTrustInterceptorModel {    
    var oneTrustSDK: OneTrustSDK!
    var categoryList = [OneTrustCategory]()
    
    init(oneTrustSDK: OneTrustSDK) {
        self.oneTrustSDK = oneTrustSDK
    }
    
    func fetchCategoryList() {
        if let domainData = oneTrustSDK.getDomainGroupData() {
            if let jsonData = try? JSONSerialization.data(withJSONObject: domainData) {
                if let result = try? JSONDecoder().decode(OneTrustDomainGroupData.self, from: jsonData), let groups = result.groups {
                    categoryList = groups
                }
            }
        }
    }
    
    func getConsentStatus(forCategoryId: String) -> Bool {
        return oneTrustSDK.getConsentStatus(forCategoryId: forCategoryId)
    }
    
    func process(message: RSMessage, with serverConfig: RSServerConfigSource) -> RSMessage {
        guard let destinations = serverConfig.destinations as? [RSServerDestination], !destinations.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptor: no destination found")
            return message
        }
        
        fetchCategoryList()
        
        guard !categoryList.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptor: no OneTrustCookieCategories found from OneTrust SDK")
            return message
        }
        
        let workingMessage = message
        var integrations = [String: NSObject]()
        for destination in destinations {
            if let integration = getIntegration(from: destination) {
                integrations.merge(integration) { (_, new) in new }
            }
        }
        if !integrations.isEmpty {
            if workingMessage.integrations.contains(where: { (key, _) in
                return key == "All"
            }) {
                workingMessage.integrations = integrations
            } else {
                workingMessage.integrations.merge(integrations) { (_, new) in new }
            }
        }
        return workingMessage
    }
    
    func getIntegration(from destination: RSServerDestination) -> [String: NSObject]? {
        var isEnabled = false
        var integration = [String: NSObject]()
        guard let destinationConfig: DestinationConfig? = getDestinationConfig(from: destination),
              let oneTrustCookieCategories = destinationConfig?.oneTrustCookieCategories, !oneTrustCookieCategories.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptor: no OneTrustCookieCategories found from Config BE for \(destination.destinationName)")
            return nil
        }
        for oneTrustCookieCategory in oneTrustCookieCategories {
            if let group = categoryList.first(where: { oneTrustGroup in
                return (oneTrustGroup.optanonGroupId == oneTrustCookieCategory || oneTrustGroup.groupName == oneTrustCookieCategory)
            }) {
                isEnabled = getConsentStatus(forCategoryId: group.optanonGroupId)
                if !isEnabled {
                    break
                }
            }
        }
        integration[destination.destinationDefinition.displayName] = NSNumber(booleanLiteral: isEnabled)
        return integration
    }
    
    
    func getDestinationConfig<T: Codable>(from destination: RSServerDestination?) -> T? {
        if let config: [String: Any] = destination?.destinationConfig as? [String: Any] {
            if let jsonData = try? JSONSerialization.data(withJSONObject: config) {
                return try? JSONDecoder().decode(T.self, from: jsonData)
            }
        }
        return nil
    }
}
