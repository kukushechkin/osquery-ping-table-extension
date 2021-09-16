table_name("ping")

description("Sends ping and checks returns latency to specified hosts.")

schema([
    Column("host", TEXT, "host or ip"),
    Column("latency", DOUBLE, "latency or INFINITY if unreachable"),
])

implementation("ping@PingTableExt")