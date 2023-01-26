//
//  RudderConfig.swift
//  RudderOneTrust
//
//  Created by Pallab Maiti on 26/01/23.
//

import Foundation

class RudderConfig: Codable {
    let WRITE_KEY: String
    let PROD_DATA_PLANE_URL: String
    let PROD_CONTROL_PLANE_URL: String
    let LOCAL_DATA_PLANE_URL: String
    let LOCAL_CONTROL_PLANE_URL: String
    let DEV_DATA_PLANE_URL: String
    let DEV_CONTROL_PLANE_URL: String
    let STORAGE_LOCATION: String
    let DOMAIN_IDENTIFIER: String
}
