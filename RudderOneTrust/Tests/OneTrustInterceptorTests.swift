//
//  OneTrustTests.swift
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

final class OneTrustInterceptorTests: XCTestCase {

    var oneTrustInterceptor: OneTrustInterceptor!
    var serverConfig: RSServerConfigSource!
    var testUtils: TestUtils!
    
    override func setUp() {
        super.setUp()
        testUtils = TestUtils()
        oneTrustInterceptor = OneTrustInterceptor()
        serverConfig = testUtils.getServerConfig(forResource: "test-mix-destination-mix-category", ofType: "json")
    }
    
    func testOneTrustSDK() {
        let oneTrustSDK = oneTrustInterceptor.getOneTrustSDK()
#if os(tvOS)
        XCTAssertTrue(oneTrustSDK  is tvOSSDK)
#else
        XCTAssertTrue(oneTrustSDK  is iOSSDK)
#endif
    }
    
    func testInterceptorModel() {
        let message = testUtils.buildTrackMessage("Test Track")
        let interceptorModel = OneTrustInterceptorModel(oneTrustSDK: TestSDK())
        let updatedMessage = interceptorModel.process(message: message, with: serverConfig)
        XCTAssertNotNil(updatedMessage.integrations)
    }
     
    override func tearDown() {
        super.tearDown()
        oneTrustInterceptor = nil
        serverConfig = nil
        testUtils = nil
    }
}
