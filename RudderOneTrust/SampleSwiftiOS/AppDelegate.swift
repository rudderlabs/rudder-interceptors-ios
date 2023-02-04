//
//  AppDelegate.swift
//  SampleSwiftiOS
//
//  Created by Pallab Maiti on 24/01/23.
//

import UIKit
import OTPublishersHeadlessSDK
import Rudder
import RudderOneTrustConsentFilter
import Rudder_Braze
import Rudder_Adjust
import Rudder_Facebook
import Rudder_Firebase
import Rudder_Appsflyer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let path = Bundle.main.path(forResource: "RudderConfig", ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let rudderConfig = try? PropertyListDecoder().decode(RudderConfig.self, from: data) else {
            return true
        }
        
        // It is recommended to initialise Rudder SDK after successful initialisation of OTPublishersHeadlessSDK
        OTPublishersHeadlessSDK.shared.startSDK(
            storageLocation: rudderConfig.STORAGE_LOCATION,
            domainIdentifier: rudderConfig.DOMAIN_IDENTIFIER,
            languageCode: "en"
        ) { response in
            if response.status {
                let builder: RSConfigBuilder = RSConfigBuilder()
                    .withLoglevel(RSLogLevelDebug)
                    .withDataPlaneUrl(rudderConfig.LOCAL_DATA_PLANE_URL)
                    .withControlPlaneUrl(rudderConfig.DEV_CONTROL_PLANE_URL)
                    .withFactory(RudderBrazeFactory.instance())
                    .withFactory(RudderAdjustFactory.instance())
                    .withFactory(RudderFacebookFactory.instance())
                    .withFactory(RudderFirebaseFactory.instance())
                    .withFactory(RudderAppsflyerFactory.instance())
                
                let option = RSOption()
                option.putIntegration("Firebase", isEnabled: true)
                option.putIntegration("Braze", isEnabled: true)
                option.putIntegration("AppsFlyer", isEnabled: false)
                RSClient.getInstance(rudderConfig.WRITE_KEY, config: builder.build(), options: option, consentFilter: RudderOneTrustConsentFilter())
            }
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

