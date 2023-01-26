//
//  AppDelegate.swift
//  SampleSwiftiOS
//
//  Created by Pallab Maiti on 24/01/23.
//

import UIKit
import OTPublishersHeadlessSDK
import Rudder
import RudderOneTrust

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        OTPublishersHeadlessSDK.shared.startSDK(
            storageLocation: "cdn.cookielaw.org",
            domainIdentifier: "03b4f096-bd76-48f1-8ea0-ae82b98502a7-test",
            languageCode: "en"
        ) { response in
            if response.status {
                let builder: RSConfigBuilder = RSConfigBuilder()
                    .withLoglevel(RSLogLevelDebug)
                //                    .withDataPlaneUrl("https://6523-103-242-191-121.in.ngrok.io")
                //                    .withControlPlaneUrl("https://608c-103-242-191-121.in.ngrok.io")
                    .withTrackLifecycleEvens(false)
                    .withRecordScreenViews(false)
                    .withSleepTimeOut(4)
                    .withSessionTimeoutMillis(30000)
                    .withConsent(OneTrustInterceptor())
                
//                let option = RSOption()
                //                option.putIntegration("Firebase", isEnabled: true)
                //                option.putIntegration("Adroll", isEnabled: true)
//                option.putIntegration("All", isEnabled: true)
                RSClient.getInstance("2KDT361Ms7fMlomDoi9t12aXtNX", config: builder.build())
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

