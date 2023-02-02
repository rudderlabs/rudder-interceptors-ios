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

| The RudderStack iOS SDK supports OneTrust consent management from version 1.9.0. |
| :----|

The [RudderStack iOS SDK](https://www.rudderstack.com/docs/sources/event-streams/sdks/rudderstack-ios-sdk/) lets you specify the user's consent during initialization. This readme lists the necessary steps to develop a consent interceptor for the iOS SDK and use it to initialize the SDK once the user gives their consent.

## Developing a consent interceptor

### Objective C

1. Create a `CustomConsentInterceptor.h` file by extending `RSConsentInterceptor`, as shown:

```objectivec
#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomConsentInterceptor : NSObject<RSConsentInterceptor>

@end

NS_ASSUME_NONNULL_END
```

2. Create a `CustomConsentInterceptor.m` file, as shown:

```objectivec
#import "CustomConsentInterceptor.h"

@implementation CustomConsentInterceptor

- (nonnull RSMessage *)interceptWithServerConfig:(nonnull RSServerConfigSource *)serverConfig andMessage:(nonnull RSMessage *)message {
    RSMessage *updatedMessage = message;
    // Do someting
    return updatedMessage;
}

@end
```

### Swift

1. Create a `CustomConsentInterceptor` file by extending `RSConsentInterceptor`, as shown:

```swift
@objc
open class OneTrustInterceptor: NSObject, RSConsentInterceptor {
        
    @objc
    public override init() {
        super.init()
    }
    
    public func intercept(withServerConfig serverConfig: RSServerConfigSource, andMessage message: RSMessage) -> RSMessage {        
				let updatedMessage = message
				// Do something
        return updatedMessage
    }
}
```

## Registering interceptor with iOS SDK

You can register `CustomConsentInterceptor` with the iOS SDK during the initialization, as shown:

### Objective C

```objectivec
RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
[builder withLoglevel:RSLogLevelDebug];
[builder withDataPlaneUrl:DATA_PLANE_URL];
[builder withConsentInterceptor:[[CustomConsentInterceptor alloc] init]];

[RSClient getInstance:WRITE_KEY config:builder.build];
```

### Swift

```swift
let builder: RSConfigBuilder = RSConfigBuilder()
		.withLoglevel(RSLogLevelDebug)
		.withDataPlaneUrl(DATA_PLANE_URL)
		.withConsentInterceptor(CustomConsentInterceptor())
             
RSClient.getInstance(rudderConfig.WRITE_KEY, config: builder.build())
```

## Installing OneTrust consent

1. Install `RudderOneTrust` by adding the following line to your `Podfile`:

```ruby
pod 'RudderOneTrust', '~> 1.0.0'
```

2. Import the SDK, as shown:

#### Objective C

```objectivec
@import RudderOneTrust;
```

#### Swift

```swift
import RudderOneTrust
```

3. Finally, add the imports to your `AppDelegate` file under the `didFinishLaunchingWithOptions` method:

#### Objective C

```objectivec
[[OTPublishersHeadlessSDK shared] startSDKWithStorageLocation:STORAGE_LOCATION domainIdentifier:DOMAIN_IDENTIFIER languageCode:@"en" params:nil loadOffline:NO completionHandler:^(OTResponse *response) {
    if (response.status) {
        RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
        [builder withLoglevel:RSLogLevelDebug];
        [builder withDataPlaneUrl:DATA_PLANE_URL];
        [builder withConsentInterceptor:[[OneTrustInterceptor alloc] init]];

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
            .withConsentInterceptor(OneTrustInterceptor())
             
        RSClient.getInstance(rudderConfig.WRITE_KEY, config: builder.build())
    }
}
```

| Important: Make sure you load the SDK only after the user provides their consent. |
| :----|

## License

This feature is released under the [**MIT License**](https://opensource.org/licenses/MIT).
