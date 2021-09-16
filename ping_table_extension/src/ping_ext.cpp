#include "ping_ext.h"
#include <Ping.h>

#include <iostream>

TableColumns PingTableExt::columns() const {
  return {
      std::make_tuple("host", TEXT_TYPE, ColumnOptions::DEFAULT),
      std::make_tuple("latency", DOUBLE_TYPE, ColumnOptions::DEFAULT),
  };
}

TableRows PingTableExt::generate(QueryContext& context) {
  TableRows results;
  
  auto hosts = context.constraints["host"].getAll(EQUALS);
  for(const auto & host: hosts) {
    auto r = make_table_row();
    r["host"] = host;
    r["latency"] = DOUBLE(Ping::latencyForDestination(host));
    results.push_back(std::move(r));
  }
  
  return results;
}