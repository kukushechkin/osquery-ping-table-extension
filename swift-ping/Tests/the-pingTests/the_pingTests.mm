#import <XCTest/XCTest.h>

@import the_ping;

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
    double latency = Ping::latencyForDestination("127.0.0.1");
    XCTAssertTrue(latency > 0);
    XCTAssertTrue(latency < INFINITY);
    XCTAssertTrue(latency != 42.0); // the usual hardcoded test value
}

@end
