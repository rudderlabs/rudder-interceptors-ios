//
//  TestCookieCategory.swift
//
//  Created by Pallab Maiti on 25/01/23.
//

import Foundation
#if os(tvOS)
@testable import RudderOneTrusttvOS
#else
@testable import RudderOneTrustiOS
#endif
@testable import Rudder

class TestCookieCategory: CookieCategory {
    var destination: RSServerDestination!
    
    init(destination: RSServerDestination) {
        self.destination = destination
    }
    
    func getRudderOneTrustCookieCategories() -> [String]? {
        return ["Strictly Necessary Cookies", "CAT03"]
    }
}
