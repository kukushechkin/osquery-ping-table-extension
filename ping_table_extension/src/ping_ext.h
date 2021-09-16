#include <osquery/core/system.h>
#include <osquery/sdk/sdk.h>
#include <osquery/sql/dynamic_table_row.h>

using namespace osquery;

class PingTableExt : public TablePlugin {
public:
    TableRows generate(QueryContext& request);
private:
    TableColumns columns() const;
};