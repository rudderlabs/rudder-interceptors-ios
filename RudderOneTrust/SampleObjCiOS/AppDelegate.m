//
//  AppDelegate.m
//  SampleObjCiOS
//
//  Created by Pallab Maiti on 30/01/23.
//

#import "AppDelegate.h"
#import "SampleObjCiOS-Swift.h"
#import "Rudder.h"

@import RudderOneTrust;
@import OTPublishersHeadlessSDK;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RudderConfig" ofType:@"plist"];
    if (path != nil) {
        NSURL *url = [NSURL fileURLWithPath:path];
        RudderConfig *rudderConfig = [RudderConfig createFrom:url];
        if (rudderConfig != nil) {
            [[OTPublishersHeadlessSDK shared] startSDKWithStorageLocation:rudderConfig.STORAGE_LOCATION domainIdentifier:rudderConfig.DOMAIN_IDENTIFIER languageCode:@"en" params:nil loadOffline:NO completionHandler:^(OTResponse *response) {
                if (response.status) {
                    RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
                    [builder withLoglevel:RSLogLevelDebug];
                    [builder withDataPlaneUrl:rudderConfig.DEV_DATA_PLANE_URL];
                    [builder withConsentInterceptor:[[OneTrustInterceptor alloc] init]];
                    
                    [RSClient getInstance:rudderConfig.WRITE_KEY config:builder.build];
                }
            }];
        }
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
