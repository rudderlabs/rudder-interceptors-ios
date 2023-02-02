//
//  OneTrustInterceptorModelTests.swift
//
//  Created by Pallab Maiti on 25/01/23.
//

import XCTest
#if os(tvOS)
@testable import RudderOneTrusttvOS
#else
@testable import RudderOneTrustiOS
#endif
@testable import Rudder

final class OneTrustInterceptorModelTests: XCTestCase {
    
    var oneTrustInterceptorModel: OneTrustInterceptorModel!
    var oneTrustSDK: OneTrustSDK!
    
    override func setUp() {
        super.setUp()
        oneTrustSDK = TestSDK()
        oneTrustInterceptorModel = .init(oneTrustSDK: oneTrustSDK)
    }
    
    func testCategoryListNotEmpty() {
        oneTrustInterceptorModel.fetchCategoryList()
        XCTAssertTrue(!oneTrustInterceptorModel.categoryList.isEmpty)
    }
        
    func test_getIntegration() {
        let testUtils = TestUtils()
        let serverConfig = testUtils.getServerConfig(forResource: "test-some-destination-has-category", ofType: "json")
        XCTAssertNotNil(serverConfig)
        XCTAssertNotNil(serverConfig!.destinations)
        XCTAssertTrue(serverConfig!.destinations is [RSServerDestination])
        
        let destinations = serverConfig!.destinations as! [RSServerDestination]
        XCTAssertTrue(!destinations.isEmpty)
                
        oneTrustInterceptorModel.fetchCategoryList()

        XCTAssertTrue(!oneTrustInterceptorModel.categoryList.isEmpty)
        
        let destination = destinations.first { destination in
            return destination.destinationName == "Adroll Prod"
        }
        
        XCTAssertNotNil(destination)
        
        let cookieCategory: CookieCategory = TestCookieCategory(destination: destination!)
        let integration = oneTrustInterceptorModel.getIntegration(from: cookieCategory)
        XCTAssertNotNil(integration)
        XCTAssertNotNil(destination?.destinationDefinition.displayName)
                
        let value = integration![destination!.destinationDefinition.displayName]
        XCTAssertNotNil(value)
        
        XCTAssertEqual(value!, true as NSObject)
    }
}
