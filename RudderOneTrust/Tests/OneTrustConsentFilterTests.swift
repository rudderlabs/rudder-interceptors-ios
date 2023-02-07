//
//  OneTrustConsentFilterTests.swift
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

final class OneTrustConsentFilterTests: XCTestCase {
    var testUtils: TestUtils!
    var oneTrustSDK: TestSDK!

    override func setUp() {
        super.setUp()
        testUtils = TestUtils()
        oneTrustSDK = TestSDK()
    }
    
    func test_fetchCategoryList() {
        let oneTrustCategoryList = oneTrustSDK.fetchCategoryList()
        XCTAssertNotNil(oneTrustCategoryList)
        XCTAssertTrue(!oneTrustCategoryList!.isEmpty)
        XCTAssertEqual(oneTrustCategoryList!.count, 4)
    }
    
    func test_getConsentStatus() {
        XCTAssertEqual(oneTrustSDK.getConsentStatus(forCategoryId: "CAT01"), true)
        XCTAssertEqual(oneTrustSDK.getConsentStatus(forCategoryId: "CAT02"), false)
        XCTAssertEqual(oneTrustSDK.getConsentStatus(forCategoryId: "CAT03"), true)
        XCTAssertEqual(oneTrustSDK.getConsentStatus(forCategoryId: "CAT04"), true)
    }
    
    func test_getIntegration() {
        // Given
        let expected = NSNumber(booleanLiteral: false)
        
        // When
        let testUtils = TestUtils()
        let serverConfig = testUtils.getServerConfig(forResource: "test-some-destination-has-category", ofType: "json")
        XCTAssertNotNil(serverConfig)
        XCTAssertNotNil(serverConfig!.destinations)
        XCTAssertTrue(serverConfig!.destinations is [RSServerDestination])
        
        let destinations = serverConfig!.destinations as! [RSServerDestination]
        XCTAssertTrue(!destinations.isEmpty)
                
        let destination = destinations.first { destination in
            return destination.destinationName == "GA Prod"
        }
        
        XCTAssertNotNil(destination)
        
        let oneTrustConsentFilter = RudderOneTrustConsentFilter(oneTrustSDK: oneTrustSDK)
        let oneTrustCategoryList = oneTrustSDK.fetchCategoryList()
        
        XCTAssertNotNil(oneTrustCategoryList)
        XCTAssertTrue(!oneTrustCategoryList!.isEmpty)
        
        let integration = oneTrustConsentFilter.getIntegration(from: destination!, with: oneTrustCategoryList!)
        
        // Then
        XCTAssertNotNil(integration)
        XCTAssertNotNil(destination?.destinationDefinition.displayName)
        
        let value = integration![destination!.destinationDefinition.displayName]
        XCTAssertNotNil(value)
        
        XCTAssertEqual(value!, expected)
    }
    
    func test_getRudderOneTrustCategoryList() {
        // Given
        let expected = ["Strictly Necessary Cookies", "Category 2"]
        
        // When
        let testUtils = TestUtils()
        let serverConfig = testUtils.getServerConfig(forResource: "test-some-destination-has-category", ofType: "json")
        XCTAssertNotNil(serverConfig)
        XCTAssertNotNil(serverConfig!.destinations)
        XCTAssertTrue(serverConfig!.destinations is [RSServerDestination])
        
        let destinations = serverConfig!.destinations as! [RSServerDestination]
        XCTAssertTrue(!destinations.isEmpty)
                
        let destination = destinations.first { destination in
            return destination.destinationName == "GA Prod"
        }
        
        XCTAssertNotNil(destination)
        
        let oneTrustConsentFilter = RudderOneTrustConsentFilter(oneTrustSDK: oneTrustSDK)
        let rudderOneTrustCategoryList = oneTrustConsentFilter.getRudderOneTrustCategoryList(destination: destination!)
        
        // Then
        XCTAssertNotNil(rudderOneTrustCategoryList)
        XCTAssertTrue(!rudderOneTrustCategoryList!.isEmpty)
        XCTAssertEqual(rudderOneTrustCategoryList!, expected)
    }
    
    func test_getDestinationConfig() {
        // Given
        let expected = ["Strictly Necessary Cookies", "Category 2"]
        
        // When
        let testUtils = TestUtils()
        let serverConfig = testUtils.getServerConfig(forResource: "test-some-destination-has-category", ofType: "json")
        XCTAssertNotNil(serverConfig)
        XCTAssertNotNil(serverConfig!.destinations)
        XCTAssertTrue(serverConfig!.destinations is [RSServerDestination])
        
        let destinations = serverConfig!.destinations as! [RSServerDestination]
        XCTAssertTrue(!destinations.isEmpty)
                
        let destination = destinations.first { destination in
            return destination.destinationName == "GA Prod"
        }
        
        XCTAssertNotNil(destination)
        
        let oneTrustConsentFilter = RudderOneTrustConsentFilter(oneTrustSDK: oneTrustSDK)
        let destinationConfig = oneTrustConsentFilter.getDestinationConfig(destination: destination!)
        
        // Then
        XCTAssertNotNil(destinationConfig)
        XCTAssertEqual(destinationConfig?.oneTrustCookieCategories, expected)
    }
    
    func testSomeDestinationHasCategory() {
        // Given
        let expected: [String: NSNumber] = [
            "Amplitude": NSNumber(booleanLiteral: false),
            "Google Analytics": NSNumber(booleanLiteral: false),
            "Adroll": NSNumber(booleanLiteral: true)
        ]
        
        // When
        let oneTrustConsentFilter = RudderOneTrustConsentFilter(oneTrustSDK: oneTrustSDK)
        let serverConfig = testUtils.getServerConfig(forResource: "test-some-destination-has-category", ofType: "json")
        XCTAssertNotNil(serverConfig)
        XCTAssertTrue(serverConfig!.destinations is [RSServerDestination])
        let integrations = oneTrustConsentFilter.filterConsentedDestinations(serverConfig!.destinations as! [RSServerDestination])
        
        // Then
        XCTAssertEqual(integrations, expected)
    }
        
    func testDestinationHasNoCategory() {
        // Given
        let expected: [String: NSNumber]? = nil
        
        // When
        let oneTrustConsentFilter = RudderOneTrustConsentFilter(oneTrustSDK: oneTrustSDK)
        let serverConfig = testUtils.getServerConfig(forResource: "test-destination-has-no-category", ofType: "json")
        XCTAssertNotNil(serverConfig)
        XCTAssertTrue(serverConfig!.destinations is [RSServerDestination])
        let integrations = oneTrustConsentFilter.filterConsentedDestinations(serverConfig!.destinations as! [RSServerDestination])
        
        // Then
        XCTAssertEqual(integrations, expected)
    }
        
    func testAllDestinationHasCategory() {
        // Given
        let expected: [String: NSNumber] = [
            "Amplitude": NSNumber(booleanLiteral: false),
            "Google Analytics": NSNumber(booleanLiteral: false),
            "Appcues": NSNumber(booleanLiteral: true),
            "Adroll": NSNumber(booleanLiteral: true)
        ]
        
        // When
        let oneTrustConsentFilter = RudderOneTrustConsentFilter(oneTrustSDK: oneTrustSDK)
        let serverConfig = testUtils.getServerConfig(forResource: "test-all-destination-has-category", ofType: "json")
        XCTAssertNotNil(serverConfig)
        XCTAssertTrue(serverConfig!.destinations is [RSServerDestination])
        let integrations = oneTrustConsentFilter.filterConsentedDestinations(serverConfig!.destinations as! [RSServerDestination])
        
        // Then
        XCTAssertEqual(integrations, expected)
    }
         
    override func tearDown() {
        super.tearDown()
        testUtils = nil
    }
}
