//
//  OneTrustTests.swift
//  OneTrustTests
//
//  Created by Pallab Maiti on 21/01/23.
//

import XCTest
#if os(tvOS)
@testable import RudderOneTrusttvOS
#else
@testable import RudderOneTrustiOS
#endif
@testable import Rudder

final class OneTrustTests: XCTestCase {

    var oneTrustInterceptor: OneTrustInterceptor!
    var serverConfigManager: RSServerConfigManager!
    var serverConfig: RSServerConfigSource!
    var rudderConfig: RSConfig!
    let WRITE_KEY = "WRITE_KEY"
    var testUtils: TestUtils!
    
    override func setUp() {
        super.setUp()
        testUtils = TestUtils()
        oneTrustInterceptor = OneTrustInterceptor()
        rudderConfig = RSConfigBuilder()
            .build()
        serverConfigManager = RSServerConfigManager(WRITE_KEY, rudderConfig: rudderConfig)
        let jsonString = testUtils.getJSONString(forResource: "ServerConfig", ofType: "json")
        serverConfig = serverConfigManager._parseConfig(jsonString)
    }
    
    func testOneTrustSDK() {
        let oneTrustSDK = oneTrustInterceptor.getOneTrustSDK()
#if os(tvOS)
        XCTAssertTrue(oneTrustSDK  is tvOSSDK)
#else
        XCTAssertTrue(oneTrustSDK  is iOSSDK)
#endif
    }
    
    func testEmptyIntegration() {
        let message = testUtils.buildTrackMessage("Test Track")
        let updatedMessage = oneTrustInterceptor.intercept(withServerConfig: serverConfig, andMessage: message)
        XCTAssertEqual(updatedMessage.integrations, [:])
    }
    
    func testInterceptorModel() {
        let message = TestUtils().buildTrackMessage("Test Track")
        let interceptorModel = OneTrustInterceptorModel(oneTrustSDK: TestSDK())
        let updatedMessage = interceptorModel.process(message: message, with: serverConfig)
        XCTAssertNotNil(updatedMessage.integrations)
    }
     
    override func tearDown() {
        super.tearDown()
        oneTrustInterceptor = nil
        rudderConfig = nil
        serverConfig = nil
    }
}
