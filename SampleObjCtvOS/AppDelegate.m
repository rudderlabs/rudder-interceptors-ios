//
//  AppDelegate.m
//  SampleObjCtvOS
//
//  Created by Pallab Maiti on 30/01/23.
//

#import "AppDelegate.h"
#import "SampleObjCtvOS-Swift.h"
#import "Rudder.h"

@import RudderOneTrustConsentFilter;
@import OTPublishersHeadlessSDKtvOS;

@interface AppDelegate ()<OTEventListener> {
    RudderConfig *rudderConfig;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RudderConfig" ofType:@"plist"];
    if (path != nil) {
        NSURL *url = [NSURL fileURLWithPath:path];
        RudderConfig *rudderConfig = [RudderConfig createFrom:url];
        if (rudderConfig != nil) {
            self->rudderConfig = rudderConfig;
            [[OTPublishersHeadlessSDK shared] startSDKWithStorageLocation:rudderConfig.STORAGE_LOCATION domainIdentifier:rudderConfig.DOMAIN_IDENTIFIER languageCode:@"en" params:nil loadOffline:NO completionHandler:^(OTResponse *response) {
                if (response.status) {
                    
                }
            }];
        }
    }
    return YES;
}

- (void)initializeRudderSDK {
    if (rudderConfig == nil) {
        return;
    }
    RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
    [builder withLoglevel:RSLogLevelDebug];
    [builder withDataPlaneUrl:rudderConfig.DEV_DATA_PLANE_URL];
    [builder withControlPlaneUrl:rudderConfig.DEV_CONTROL_PLANE_URL];
    [builder withConsentFilter:[[RudderOneTrustConsentFilter alloc] init]];
    
    [RSClient getInstance:rudderConfig.WRITE_KEY config:builder.build];
}

- (void)onPreferenceCenterConfirmChoices {
    [self initializeRudderSDK];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


@end
