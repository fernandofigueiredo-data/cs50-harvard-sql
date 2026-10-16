# From the Deep

In this problem, you'll write freeform responses to the questions provided in the specification.

## Random Partitioning

Random partitioning spreads observations fairly evenly, so no boat ends up holding most of the data. The catch is queries. A search over a time range has to run on every boat, because any matching record could be on any of them.

## Partitioning by Hour

Splitting by hour makes time-range queries cheap, since each hour lives on one known boat. The problem is that AquaByte's data isn't spread across the day. Most observations arrive between midnight and 1am, so Boat A would take nearly all of them and become the bottleneck.

## Partitioning by Hash Value

Hashing the timestamp spreads data about as evenly as random partitioning, and it lets the system find one observation by computing the hash and going straight to the right boat. Range queries get no such help. Timestamps that are close together hash to unrelated values, so a range query still has to run on every boat.
