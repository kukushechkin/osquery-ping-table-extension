#import <Foundation/Foundation.h>

#import "../SimplePing.h"

@interface SimplePingObj : NSObject <SimplePingDelegate>

@property NSTimeInterval duration;

- (NSTimeInterval)singlePingWithHostName:(NSString *_Nonnull)hostName;

@end
