#import <Foundation/Foundation.h>

@import SimplePing;

@interface Main : NSObject <SimplePingDelegate>

@property NSTimeInterval duration;

- (NSTimeInterval)singlePingWithHostName:(NSString *_Nonnull)hostName;

@end
