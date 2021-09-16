# osquery-ping-table-extension

A osquery table extension with ping data. 

## Implementation decisions

// meh

# prerequisitions
* cmake
* osquery & it's dependencies (cmake, flex, bison, glog)

## build steps

Based on [osquery external extension guide](https://osquery.readthedocs.io/en/stable/development/osquery-sdk/#building-external-extensions)

* run OSQUERY_SOURCE_PATH=<path_to_osquery_repo> build.sh
* osqueryi --extension $OSQUERY_SOURCE_PATH/build/external/external_extension_ping.ext

## samples

osquery> select * from ping where (host = '127.0.0.1' or host = 'ya.ru') and latency < '0.01';
127.0.0.1
ya.ru
+-----------+----------+
| host      | latency  |
+-----------+----------+
| 127.0.0.1 | 0.000362 |
+-----------+----------+
osquery> select * from ping where (host = '127.0.0.1' or host = 'ya.ru') and latency < '0.03';
127.0.0.1
ya.ru
+-----------+----------+
| host      | latency  |
+-----------+----------+
| 127.0.0.1 | 0.000507 |
| ya.ru     | 0.028335 |
+-----------+----------+