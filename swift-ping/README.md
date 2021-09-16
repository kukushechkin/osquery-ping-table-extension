# swift-ping

A package with ping implementation library. Contains three targets:

## swifty-ping-wrapper

Wraps SwiftyPing package in an objc-compatible way. Original SwiftyPing version was broken, so forked and fixed it. Soon after that realized I don't wanna go through linking swift runtime in to the osquery extension. Abandoned and not being used. Left in the pakcage as an archeological artifact.

## SimplePing

Ping implementation from [Apple sample](https://developer.apple.com/library/archive/samplecode/SimplePing/Introduction/Intro.html). Modified to provide ping duration.

## the-ping

A C++ interface for osquery extension integration. 
