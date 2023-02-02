//
//  OneTrustInterceptorModel.swift
//  OneTrust
//
//  Created by Pallab Maiti on 20/01/23.
//

import Foundation
import Rudder

protocol OneTrustSDK {
    func fetchCategoryList() -> [OneTrustCategory]?
    
    func getConsentStatus(forCategoryId: String) -> Bool
}

class OneTrustInterceptorModel {    
    var oneTrustSDK: OneTrustSDK!
    var categoryList = [OneTrustCategory]()
    
    init(oneTrustSDK: OneTrustSDK) {
        self.oneTrustSDK = oneTrustSDK
    }
    
    func fetchCategoryList() {
        if let categoryList = oneTrustSDK.fetchCategoryList() {
            self.categoryList = categoryList
        }
    }
    
    func process(message: RSMessage, with serverConfig: RSServerConfigSource) -> RSMessage {
        guard let destinations = serverConfig.destinations as? [RSServerDestination], !destinations.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptorModel: no destination found")
            return message
        }
        
        fetchCategoryList()
        
        guard !categoryList.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptorModel: no OneTrustCookieCategories found from OneTrust SDK")
            return message
        }
        
        var integrations = [String: NSObject]()
        for destination in destinations {
            let cookieCategory: CookieCategory = OneTrustCookieCategory(destination: destination)
            if let integration = getIntegration(from: cookieCategory) {
                integrations.merge(integration) { (_, new) in new }
            }
        }
        
        let workingMessage = message
        if !integrations.isEmpty {
            workingMessage.integrations.merge(integrations) { (_, new) in new }
            // Remove integrations those are true except All
            workingMessage.integrations = workingMessage.integrations.filter({ $0.key == "All" || $0.value == NSNumber(booleanLiteral: false)})
        }
        return workingMessage
    }
    
    func getIntegration(from cookieCategory: CookieCategory) -> [String: NSObject]? {
        guard let rudderOneTrustCookieCategories = cookieCategory.getRudderOneTrustCookieCategories(), !rudderOneTrustCookieCategories.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptorModel: no OneTrustCookieCategories found from Config BE for \(cookieCategory.destination.destinationName)")
            return nil
        }
        var isEnabled = false
        var integration = [String: NSObject]()
        for oneTrustCookieCategory in rudderOneTrustCookieCategories {
            if let group = categoryList.first(where: { oneTrustGroup in
                return (oneTrustGroup.optanonGroupId == oneTrustCookieCategory || oneTrustGroup.groupName == oneTrustCookieCategory)
            }) {
                isEnabled = oneTrustSDK.getConsentStatus(forCategoryId: group.optanonGroupId)
                if !isEnabled {
                    break
                }
            }
        }
        integration[cookieCategory.destination.destinationDefinition.displayName] = NSNumber(booleanLiteral: isEnabled)
        return integration
    }
}
