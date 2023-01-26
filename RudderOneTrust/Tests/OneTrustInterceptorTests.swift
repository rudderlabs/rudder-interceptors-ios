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
    }
    
    func testOneTrustSDK() {
        let oneTrustSDK = oneTrustInterceptor.getOneTrustSDK()
#if os(tvOS)
        XCTAssertTrue(oneTrustSDK  is tvOSSDK)
#else
        XCTAssertTrue(oneTrustSDK  is iOSSDK)
#endif
    }
    
    func testSomeDestinationHasCategory() {
        // Given
        let expected: [String: NSObject] = [
            "All": true as NSObject,
            "Amplitude": false as NSObject,
            "Adroll": true as NSObject,
            "Google Analytics": false as NSObject
        ]
        
        // When
        oneTrustInterceptor.interceptorModel = OneTrustInterceptorModel(oneTrustSDK: TestSDK())
        let serverConfig = testUtils.getServerConfig(forResource: "test-some-destination-has-category", ofType: "json")
        let message = testUtils.buildTrackMessage("Test Track")
        let updatedMessage = oneTrustInterceptor.intercept(withServerConfig: serverConfig, andMessage: message)
        
        // Then
        XCTAssertEqual(updatedMessage.integrations, expected)
    }
    
    func testSomeDestinationHasCategoryWithOptions() {
        // Given
        let expected: [String: NSObject] = [
            "Amplitude": false as NSObject,
            "Adroll": true as NSObject,
            "Google Analytics": false as NSObject
        ]
        
        // When
        oneTrustInterceptor.interceptorModel = OneTrustInterceptorModel(oneTrustSDK: TestSDK())
        let serverConfig = testUtils.getServerConfig(forResource: "test-some-destination-has-category", ofType: "json")
        let options = RSOption()
        options.putIntegration("Amplitude", isEnabled: true)
        let message = testUtils.buildTrackMessage("Test Track", options: options)
        let updatedMessage = oneTrustInterceptor.intercept(withServerConfig: serverConfig, andMessage: message)
        
        // Then
        XCTAssertEqual(updatedMessage.integrations, expected)
    }
    
    func testDestinationHasNoCategory() {
        // Given
        let expected: [String: NSObject] = [
            "All": true as NSObject
        ]
        
        // When
        oneTrustInterceptor.interceptorModel = OneTrustInterceptorModel(oneTrustSDK: TestSDK())
        let serverConfig = testUtils.getServerConfig(forResource: "test-destination-has-no-category", ofType: "json")
        let message = testUtils.buildTrackMessage("Test Track")
        let updatedMessage = oneTrustInterceptor.intercept(withServerConfig: serverConfig, andMessage: message)
        
        // Then
        XCTAssertEqual(updatedMessage.integrations, expected)
    }
    
    func testDestinationHasNoCategoryWithOption() {
        // Given
        let expected: [String: NSObject] = [
            "Amplitude": true as NSObject
        ]
        
        // When
        oneTrustInterceptor.interceptorModel = OneTrustInterceptorModel(oneTrustSDK: TestSDK())
        let serverConfig = testUtils.getServerConfig(forResource: "test-destination-has-no-category", ofType: "json")
        let options = RSOption()
        options.putIntegration("Amplitude", isEnabled: true)
        let message = testUtils.buildTrackMessage("Test Track", options: options)
        let updatedMessage = oneTrustInterceptor.intercept(withServerConfig: serverConfig, andMessage: message)
        
        // Then
        XCTAssertEqual(updatedMessage.integrations, expected)
    }
    
    func testAllDestinationHasCategory() {
        // Given
        let expected: [String: NSObject] = [
            "All": true as NSObject,
            "Amplitude": false as NSObject,
            "Adroll": true as NSObject,
            "Google Analytics": false as NSObject,
            "Appcues": true as NSObject
        ]
        
        // When
        oneTrustInterceptor.interceptorModel = OneTrustInterceptorModel(oneTrustSDK: TestSDK())
        let serverConfig = testUtils.getServerConfig(forResource: "test-all-destination-has-category", ofType: "json")
        let message = testUtils.buildTrackMessage("Test Track")
        let updatedMessage = oneTrustInterceptor.intercept(withServerConfig: serverConfig, andMessage: message)
        
        // Then
        XCTAssertEqual(updatedMessage.integrations, expected)
    }
    
    func testAllDestinationHasCategoryWithOption() {
        // Given
        let expected: [String: NSObject] = [
            "Amplitude": false as NSObject,
            "Adroll": true as NSObject,
            "Google Analytics": false as NSObject,
            "Appcues": true as NSObject
        ]
        
        // When
        oneTrustInterceptor.interceptorModel = OneTrustInterceptorModel(oneTrustSDK: TestSDK())
        let serverConfig = testUtils.getServerConfig(forResource: "test-all-destination-has-category", ofType: "json")
        let options = RSOption()
        options.putIntegration("Amplitude", isEnabled: true)
        let message = testUtils.buildTrackMessage("Test Track", options: options)
        let updatedMessage = oneTrustInterceptor.intercept(withServerConfig: serverConfig, andMessage: message)
        
        // Then
        XCTAssertEqual(updatedMessage.integrations, expected)
    }
     
    override func tearDown() {
        super.tearDown()
        oneTrustInterceptor = nil
        serverConfig = nil
        testUtils = nil
    }
}
