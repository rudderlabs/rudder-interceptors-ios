//
//  AppDelegate.swift
//  SampleSwifttvOS
//
//  Created by Pallab Maiti on 24/01/23.
//

import UIKit
import OTPublishersHeadlessSDKtvOS
import Rudder
import RudderOneTrust

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


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
                
                let option = RSOption()
                //                option.putIntegration("Firebase", isEnabled: true)
                //                option.putIntegration("Adroll", isEnabled: true)
                option.putIntegration("All", isEnabled: true)
                RSClient.getInstance("2KDT361Ms7fMlomDoi9t12aXtNX", config: builder.build(), options: option)
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

