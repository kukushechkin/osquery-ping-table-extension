# osquery-ping-table-extension

An osquery table extension providing ping duration. Spec:

```python
table_name("ping")
description("Sends ping and checks returns latency to specified hosts.")
schema([
    Column("host", TEXT, "host or ip"),
    Column("latency", DOUBLE, "latency or Inf if unreachable"),
])
implementation("ping@PingTableExt")
```



## Implementation decisions

Several decisions were made:

1. Build an extension based on osquery template and leverage build tools and Thrift implementation [included in osquery](https://osquery.readthedocs.io/en/latest/development/osquery-sdk/#building-external-extensions). Rationale — save time on figuring out how osquery extensions protocol works and use 1st party tooling. Sounded reasonable, but ran into support issues, e.g. osquery does not support building natively on Apple Silicon, took some time poking it around to build in Rosetta, but seemed more reasonable to switch to an Intel device.
2. Use Swift Package Manager to maintain dependencies. The plan was to take into use some shiny swift library with ping implementation and plug it through SPM and save on dependencies management in CMake. Swift library was found, but it a. did not work and required fixes and b. linking with osquery extension was a mess. Switched to an objc implementation based on [Apple SimplePing sample](https://developer.apple.com/library/archive/samplecode/SimplePing/Introduction/Intro.html), this part worked out fine.
3. build and run script — the fastest way to glue an unusual workflow for osquery extension implementation
4. Tests:
   1. `single-ping-lib` library contains trivial tests for verifying reachable/unreachable destinations. Not much to unit test.
   2. 3rd party code from SimplePing has no unittests and is not easily testable. It is the most delicate part as it actually deals with user input and networking, so it is kinda wrong to not to have any tests there, but the assumption for the given timeframe was "it is old enough, so it means it is good enough"
   3. osquery extension has trivial logic and relies on osquery tests
   4. tested manually on a different device from where the extension was built

Overall took ~ 8 hours during the day. Around 80% of the time spent on figuring out how to build osquery and, well, actually building it (yes, boost).

An alternative path for implementation might have been to not to deal with osquery template, implement communication between the extension and osquery manually using some Thrift implementation. This will allow more flexebility in terms of tooling, but will introduce a lot of code.



## Prerequisitions
* Xcode 12+ (tested with Xcode 13 beta)

* osquery installation

* osquery sources

* osquery dependencies (cmake, [homebrew], flex, bison, glog)

  

## Build and run

`OSQUERY_SOURCE_PATH=<path_to_osquery_repo> build-and-run.sh`



## Sample queries

```shell
osquery> select * from ping where (host = '127.0.0.1' or host = 'apple.com') and latency < '6';
+-----------+----------+
| host      | latency  |
+-----------+----------+
| 127.0.0.1 | 0.540972 |
+-----------+----------+

osquery> select * from ping where (host = '127.0.0.1' or host = 'apple.com') and latency < '60';
+-----------+-----------+
| host      | latency   |
+-----------+-----------+
| 127.0.0.1 | 0.877976  |
| apple.com | 56.755066 |
+-----------+-----------+

osquery> select * from ping where host = 'apple.com' or host ='127.0.0.1' or host ='asdasdasda';
+------------+-----------+
| host       | latency   |
+------------+-----------+
| 127.0.0.1  | 0.712991  |
| apple.com  | 57.023048 |
| asdasdasda | Inf       |
+------------+-----------+
```

