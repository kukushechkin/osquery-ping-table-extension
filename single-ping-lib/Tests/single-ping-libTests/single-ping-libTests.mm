#import <XCTest/XCTest.h>

@import single_ping_lib;

@interface FSCCodesignTests : XCTestCase

@end

@implementation FSCCodesignTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPing {
    double latency = Ping::latencyForDestination("1.1.1.1");
    XCTAssertTrue(latency > 0);
    XCTAssertTrue(latency < INFINITY);
    XCTAssertTrue(latency != 42.0); // the usual hardcoded test value
}

- (void)testPingUnreachable {
    double latency = Ping::latencyForDestination("asdklajskldja");
    XCTAssertEqual(latency, INFINITY);
}

@end
