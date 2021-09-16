#import "include/Ping.h"

@import swifty_ping_wrapper;

double latencyForDestination(const std::string&& dest) {
    // TODO: stringWithUTF8String: will copy string, not great
    NSString * destination = [NSString stringWithUTF8String:dest.c_str()];
    return [SwiftyPing_wrapper latencyForDestinationWithDest:destination];
}
