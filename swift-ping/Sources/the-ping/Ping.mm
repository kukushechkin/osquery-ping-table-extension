#import "include/Ping.h"

#import "MainObj.h"

double latencyForDestination(const std::string&& dest) {
    // TODO: stringWithUTF8String: will copy string, not great
    NSString * destination = [NSString stringWithUTF8String:dest.c_str()];
    Main * mainObj = [Main new];
    return [mainObj singlePingWithHostName:destination];
}
