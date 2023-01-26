//
//  TestUtils.swift
//
//  Created by Pallab Maiti on 24/01/23.
//

import Foundation
import Rudder

internal final class TestUtils {
        
    var rudderConfig: RSConfig {
        RSConfigBuilder().build()
    }
    
    var serverConfigManager: RSServerConfigManager {
        RSServerConfigManager("WRITE_KEY", rudderConfig: rudderConfig)
    }
    
    func getServerConfig(forResource: String, ofType: String) -> RSServerConfigSource {
        let jsonString = getJSONString(forResource: forResource, ofType: ofType)
        return serverConfigManager._parseConfig(jsonString)
    }
    
    func getPath(forResource: String, ofType: String) -> String {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: forResource, ofType: ofType) {
            return path
        } else {
            fatalError("\(forResource).\(ofType) not present in test bundle.")
        }
    }
    
    func getJSONString(forResource: String, ofType: String) -> String {
        let path = getPath(forResource: forResource, ofType: ofType)
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            let data1 = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
            if let convertedString = String(data: data1, encoding: .utf8) {
                return convertedString
            } else {
                fatalError("Can not parse or invalid JSON.")
            }
        } catch {
            fatalError("Can not parse or invalid JSON.")
        }
    }
    
    func getServerConfigFromJSON(_ writeKey: String, rudderConfig: RSConfig, jsonString: String) -> RSServerConfigSource {
        let serverConfigManager = RSServerConfigManager(writeKey, rudderConfig: rudderConfig)
        return serverConfigManager._parseConfig(jsonString)
    }
    
    func buildTrackMessage(_ event: String, properties: [String: NSObject]? = nil, options: RSOption? = nil) -> RSMessage {
        let builder = RSMessageBuilder()
        builder.setEventName(event)
        if let properties = properties {
            builder.setPropertyDict(properties)
        }
        if let options = options {
            builder.setRSOption(options)
        }
        let message = builder.build()
        message.type = RSTrack
        if message.integrations.isEmpty {
            message.integrations = ["All": true as NSObject]
        }
        return message
    }
    
    func buildScreenMessage(_ name: String, properties: [String: NSObject]? = nil, options: RSOption? = nil) -> RSMessage {
        let builder = RSMessageBuilder()
        var propertyDict = [String: NSObject]()
        if let properties = properties {
            propertyDict = properties
        }
        propertyDict["name"] = name as NSObject
        builder.setPropertyDict(propertyDict)
        builder.setEventName(name)
        if let options = options {
            builder.setRSOption(options)
        }
        let message = builder.build()
        message.type = RSScreen
        if message.integrations.isEmpty {
            message.integrations = ["All": true as NSObject]
        }
        return message
    }
    
    func buildGroupMessage(_ groupId: String, traits: [String: NSObject]? = nil, options: RSOption? = nil) -> RSMessage {
        let builder = RSMessageBuilder()
        builder.setGroupId(groupId)
        if let traits = traits {
            builder.setGroupTraits(traits)
        }
        if let options = options {
            builder.setRSOption(options)
        }
        let message = builder.build()
        message.type = RSGroup
        if message.integrations.isEmpty {
            message.integrations = ["All": true as NSObject]
        }
        return message
    }
    
    func buildAliasMessage(_ newId: String, options: RSOption? = nil) -> RSMessage {
        let context = RSElementCache.getContext()
        let traits = context.traits
        var previousId = traits["userId"]
        if previousId == nil {
            previousId = traits["id"]
        }
        traits["id"] = newId
        traits["userId"] = newId
        
        let builder = RSMessageBuilder()
        builder.setUserId(newId)
        if let options = options {
            builder.setRSOption(options)
        }
        if let prevId = previousId {
            builder.setPreviousId(String("\(prevId)"))
        }
        let message = builder.build()
        message.updateTraitsDict(traits)
        message.type = RSAlias
        if message.integrations.isEmpty {
            message.integrations = ["All": true as NSObject]
        }
        return message
    }
    
    func buildIdentifyMessage(_ userId: String, traits: [String: NSObject]? = nil, options: RSOption? = nil) -> RSMessage {
        let builder = RSMessageBuilder()
        builder.setEventName(RSIdentify)
        builder.setUserId(userId)
        if let traits = traits {
            let traitsObj = RSTraits(dict: traits)
            traitsObj.userId = userId as NSString
            builder.setTraits(traitsObj)
        }
        if let options = options {
            builder.setExternalIds(options)
            builder.setRSOption(options)
        }
        let message = builder.build()
        message.type = RSIdentify
        if message.integrations.isEmpty {
            message.integrations = ["All": true as NSObject]
        }
        return message
    }
}
