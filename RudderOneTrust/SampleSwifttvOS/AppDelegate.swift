//
//  AppDelegate.swift
//  SampleSwifttvOS
//
//  Created by Pallab Maiti on 24/01/23.
//

import UIKit
import OTPublishersHeadlessSDKtvOS
import Rudder
import RudderOneTrustConsentFilter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let path = Bundle.main.path(forResource: "RudderConfig", ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let rudderConfig = try? PropertyListDecoder().decode(RudderConfig.self, from: data) else {
            return true
        }
        
        OTPublishersHeadlessSDK.shared.startSDK(
            storageLocation: rudderConfig.STORAGE_LOCATION,
            domainIdentifier: rudderConfig.DOMAIN_IDENTIFIER,
            languageCode: "en"
        ) { response in
            if response.status {
                let builder: RSConfigBuilder = RSConfigBuilder()
                    .withLoglevel(RSLogLevelDebug)
                    .withDataPlaneUrl(rudderConfig.DEV_DATA_PLANE_URL)
                    .withControlPlaneUrl(rudderConfig.DEV_CONTROL_PLANE_URL)
                
                let option = RSOption()
                option.putIntegration("Firebase", isEnabled: true)
                option.putIntegration("Adroll", isEnabled: true)
                option.putIntegration("All", isEnabled: true)
                RSClient.getInstance(rudderConfig.WRITE_KEY, config: builder.build(), options: option, consentFilter: RudderOneTrustConsentFilter())
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

