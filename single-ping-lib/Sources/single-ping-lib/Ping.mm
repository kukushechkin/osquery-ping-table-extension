#import "include/Ping.h"

@import SimplePing;

double Ping::latencyForDestination(const std::string& dest) {
    // TODO: stringWithUTF8String: will copy string, not great, this also means move semantics make no difference
    NSString * destination = [NSString stringWithUTF8String:dest.c_str()];
    SimplePingObj* simplePingObj = [SimplePingObj new];
    NSTimeInterval latency = [simplePingObj singlePingWithHostName:destination];
    return latency == INFINITY ? latency : latency * 1000.0;
}
