<p align="center">
  <a href="https://rudderstack.com/">
    <img src="https://user-images.githubusercontent.com/59817155/121357083-1c571300-c94f-11eb-8cc7-ce6df13855c9.png">
  </a>
</p>

<p align="center"><b>The Customer Data Platform for Developers</b></p>

<p align="center">
  <b>
    <a href="https://rudderstack.com">Website</a>
    ·
    <a href="https://www.rudderstack.com/docs/sources/event-streams/sdks/rudderstack-ios-sdk/">Documentation</a>
    ·
    <a href="https://rudderstack.com/join-rudderstack-slack-community">Community Slack</a>
  </b>
</p>

---

# Consent Management for RudderStack iOS SDK

| The RudderOneTrust iOS SDK supports OneTrust consent management from Rudder version 1.10.0. |
| :----|

The [RudderStack iOS SDK](https://www.rudderstack.com/docs/sources/event-streams/sdks/rudderstack-ios-sdk/) lets you specify the user's consent during initialization. This readme lists the necessary steps to develop a consent interceptor for the iOS SDK and use it to initialize the SDK once the user gives their consent.

## Developing a consent interceptor

### Objective C

1. Create a `CustomConsentFilter.h` file by extending `RSConsentFilter`, as shown:

```objectivec
#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomConsentFilter : NSObject<RSConsentFilter>

@end

NS_ASSUME_NONNULL_END
```

2. Create a `CustomConsentFilter.m` file, as shown:

```objectivec
#import "CustomConsentFilter.h"

@implementation CustomConsentFilter

- (NSDictionary <NSString *, NSNumber *> * __nullable)filterConsentedDestinations:(NSArray <RSServerDestination *> *)destinations {
    NSDictionary <NSString *, NSNumber *> *filteredConsentedDestinations;
    // Do someting
    return filteredConsentedDestinations;
}

@end
```

### Swift

1. Create a `CustomConsentFilter` file by extending `RSConsentFilter`, as shown:

```swift
@objc
open class OneTrustInterceptor: NSObject, RSConsentFilter {
    @objc
    public override init() {
        super.init()
    }

    public func filterConsentedDestinations(_ destinations: [RSServerDestination]) -> [String: NSNumber]? {
        let filteredConsentedDestinations: [String: NSNumber]
        // Do something
        return filteredConsentedDestinations
    }
}
```

## Registering interceptor with iOS SDK

You can register `CustomConsentFilter` with the iOS SDK during the initialization, as shown:

### Objective C

```objectivec
RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
[builder withLoglevel:RSLogLevelDebug];
[builder withDataPlaneUrl:DATA_PLANE_URL];
[builder withConsentFilter:[[CustomConsentFilter alloc] init]];

[RSClient getInstance:WRITE_KEY config:builder.build];
```

### Swift

```swift
let builder: RSConfigBuilder = RSConfigBuilder()
    .withLoglevel(RSLogLevelDebug)
    .withDataPlaneUrl(DATA_PLANE_URL)
    .withConsentFilter(CustomConsentFilter())

RSClient.getInstance(rudderConfig.WRITE_KEY, config: builder.build())
```

## Installing OneTrust consent

1. Install `RudderOneTrustConsentFilter` by adding the following line to your `Podfile`:

```ruby
pod 'RudderOneTrustConsentFilter', '~> 1.0.0'
```

2. Import the SDK, as shown:

#### Objective C

```objectivec
@import RudderOneTrustConsentFilter;
```

#### Swift

```swift
import RudderOneTrustConsentFilter
```

3. Finally, add the imports to your `AppDelegate` file under the `didFinishLaunchingWithOptions` method:

#### Objective C

```objectivec
[[OTPublishersHeadlessSDK shared] startSDKWithStorageLocation:STORAGE_LOCATION domainIdentifier:DOMAIN_IDENTIFIER languageCode:@"en" params:nil loadOffline:NO completionHandler:^(OTResponse *response) {
    if (response.status) {
        RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
        [builder withLoglevel:RSLogLevelDebug];
        [builder withDataPlaneUrl:DATA_PLANE_URL];
        [builder withConsentFilter:[[RudderOneTrustConsentFilter alloc] init]];

        [RSClient getInstance:rudderConfig.WRITE_KEY config:builder.build];
    }
}];
```

#### Swift

```swift
OTPublishersHeadlessSDK.shared.startSDK(
    storageLocation: STORAGE_LOCATION,
    domainIdentifier: DOMAIN_IDENTIFIER,
    languageCode: "en"
) { response in
    if response.status {
        let builder: RSConfigBuilder = RSConfigBuilder()
            .withLoglevel(RSLogLevelDebug)
            .withDataPlaneUrl(DATA_PLANE_URL)
            .withConsentFilter(RudderOneTrustConsentFilter())

        RSClient.getInstance(rudderConfig.WRITE_KEY, config: builder.build())
    }
}
```

| Important: It is recommended to load the SDK only after initializing the OneTrust SDK successfully. |
| :----|

## License

This feature is released under the [**MIT License**](https://opensource.org/licenses/MIT).
