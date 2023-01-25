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

