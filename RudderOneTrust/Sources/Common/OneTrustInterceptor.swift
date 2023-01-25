//
//  OneTrustInterceptor.swift
//  OneTrust
//
//  Created by Pallab Maiti on 17/01/23.
//

import Foundation
import Rudder

@objc
open class OneTrustInterceptor: NSObject, RSConsentInterceptor {
    var interceptorModel: OneTrustInterceptorModel!
        
    @objc
    public override init() {
        super.init()
        interceptorModel = OneTrustInterceptorModel(oneTrustSDK: getOneTrustSDK())
    }
    
    public func intercept(withServerConfig serverConfig: RSServerConfigSource, andMessage message: RSMessage) -> RSMessage {        
        return interceptorModel.process(message: message, with: serverConfig)
        /*guard let destinations = serverConfig.destinations as? [RSServerDestination], !destinations.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptor: no destination found")
            return message
        }
                
        interceptorModel.fetchCategoryList()
        
        guard !interceptorModel.categoryList.isEmpty else {
            RSLogger.logDebug("OneTrustInterceptor: no OneTrustCookieCategories found from OneTrust SDK")
            return message
        }
        
        let workingMessage = message
        var integrations = [String: NSObject]()
        for destination in destinations {
            if let integration = interceptorModel.getIntegration(from: destination) {
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
        return workingMessage*/
    }
    
    func getOneTrustSDK() -> OneTrustSDK {
        var oneTrustSDK: OneTrustSDK
#if os(tvOS)
        oneTrustSDK = tvOSSDK()
#else
        oneTrustSDK = iOSSDK()
#endif
        return oneTrustSDK
    }
}

