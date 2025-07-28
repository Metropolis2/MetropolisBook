# Road-Network Conditions

**Table of Contents**

<!-- toc -->


METROPOLIS2 returns three files describing the road-network conditions:

- `net_cond_exp_edge_ttfs.parquet` (or `net_cond_exp_edge_ttfs.csv`): expected road-network
  conditions for the last iteration.
- `net_cond_next_exp_edge_ttfs.parquet` (or `net_cond_next_exp_edge_ttfs.csv`): expected
  road-network conditions for the iteration after the last iteration.
- `net_cond_sim_edge_ttfs.parquet` (or `net_cond_sim_edge_ttfs.csv`): simulated road-network
  conditions during the last iteration.

The road-network conditions are represented as a piecewise-linear travel-time function for each
vehicle type and each edge of the road network.
The output files report the breakpoints `(x, y)` of these piecewise-linear travel-time functions,
where the `x` value corresponds to the departure time and the `y` value corresponds to the travel
time.
The three files follow the same format described in the table below.

| Column | Data type | Nullable | Description |
| ------ | --------- | -------  | ----------- |
| `vehicle_id` | `Integer` | No | Identifier of the vehicle type (given in the input files). |
| `edge_id` | `Integer` | No | Identifier of the edge (given in the input files). |
| `departure_time` | `Float` | No | Departure time of the breakpoint, in number of seconds after midnight. |
| `travel_time` | `Float` | No | Travel time of the breakpoint, in number of seconds. |
