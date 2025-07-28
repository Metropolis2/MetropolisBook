# Road Network

**Table of Contents**

<!-- toc -->

## CSV / Parquet representation

In METROPOLIS2, a **road network** is composed of a collection of **edges** and a collection of
**vehicle types**.
A road network is thus represented by two CSV or Parquet files:

- `edges.parquet` (or `edges.csv`)
- `vehicles.parquet` (or `vehicles.csv`)

### Edges

| Column | Data type | Conditions | Constraints | Description |
| ------ | --------- | ---------- | ----------- | ----------- |
| `edge_id` | `Integer` | Mandatory | No duplicate value, no negative value | Identifier of the edge (used in some input files and used in the output). |
| `source` | `Integer` | Mandatory | No negative value | Identifier of the source node of the edge. |
| `target` | `Integer` | Mandatory | No negative value, different from `source` | Identifier of the target node of the edge. |
| `speed` | `Float` | Mandatory | Positive number | The base speed on the edge when there is no congestion, in **meters per second**. |
| `length` | `Float` | Mandatory | Positive number | The length of the edge, from source node to target node, **in meters**. |
| `lanes` | `Float` | Optional | Positive number | The number of lanes on the edge (for this edge's direction). The default value is 1. |
| `speed_density.type` | `String` | Optional | Possible values: `"FreeFlow"`, `"Bottleneck"`, `"ThreeRegimes"` | Type of speed-density function used to compute congested travel time. If `null`, the free-flow speed-density function is used. |
| `speed_density.capacity` | `Float` | Mandatory if `speed_density.type` is `"Bottleneck"`, ignored otherwise | Positive number | Capacity of the road's bottleneck when using the bottleneck speed-density function. Value is expressed in meters of vehicle headway per second. |
| `speed_density.min_density` | `Float` | Mandatory if `speed_density.type` is `"ThreeRegimes"`, ignored othewise | Between `0.0` and `1.0` | Edge density below which the speed is equal to free-flow speed. |
| `speed_density.jam_density` | `Float` | Mandatory if `speed_density.type` is `"ThreeRegimes"`, ignored othewise | Between `0.0` and `1.0`, larger than `speed_density.min_density` | Edge density above which the speed is equal to `speed_density.jam_speed`. |
| `speed_density.jam_speed` | `Float` | Mandatory if `speed_density.type` is `"ThreeRegimes"`, ignored othewise | Positive number | Speed at which all the vehicles travel in case of traffic jam, in meters per second. |
| `speed_density.beta` | `Float` | Mandatory if `speed_density.type` is `"ThreeRegimes"`, ignored othewise | Positive number | Parameter to compute the speed in the intermediate congested case. |
| `bottleneck_flow` | `Float` | Optional | Positive number | Maximum incoming and outgoing flow of vehicles at the edge's entry and exit bottlenecks, in **PCE per second**. In `null`, the incoming and outgoing flow capacities are assumed to be infinite. |
| `constant_travel_time` | `Float` | Optional | Positive number | Constant travel-time penalty for each vehicle traveling through the edge, in seconds. If `null`, there is no travel-time penalty. |
| `overtaking` | `Boolean` | Optional | | If `true`, a vehicle that is pending at the end of the edge to enter its outgoing edge is not prevending the following vehicles to access their outgoing edges. Default value is `true`. |


### Vehicle types

| Column | Data type | Conditions | Constraints | Description |
| ------ | --------- | ---------- | ----------- | ----------- |
| `vehicle_id` | `Integer` | Mandatory | No duplicate value, no negative value | Identifier of the vehicle type |
| `headway` | `Float` | Mandatory | Non-negative value | Typical length, in **meters**, between two vehicles, from head to head. |
| `pce` | `Float` | Optional | Non-negative value | Passenger car equivalent of this vehicle type, used to compute bottleneck flows. Default value is 1. |
| `speed_function.type` | `String` | Optional | Possible values: `"Base"`, `"UpperBound"`, `"Multiplicator"`, `"Piecewise"` | Type of the function used to convert from the base edge speed to the vehicle-specific edge speed. If `null`, the base speed is used. |
| `speed_function.upper_bound` | `Float` | Mandatory if `speed_function.type` is `"UpperBound"`, ignored otherwise | Positive number | Maximum speed allowed for the vehicle type, in meters per second. |
| `speed_function.coef` | `Float` | Mandatory if `speed_function.type` is `"Multiplicator"`, ignored otherwise | Positive number | Multiplicator applied to the edge's base speed to compute the vehicle-specific speed. |
| `speed_function.x` | `List` of `Float` | Mandatory if `speed_function.type` is `"Piecewise"`, ignored otherwise | Positive numbers in increasing order | Base speed values, in meters per second, for the piece-wise linear function. |
| `speed_function.y` | `List` of `Float` | Mandatory is `speed_function.type` is `"Piecewise"`, ignored otherwise | Positive numbers, same number of values as `speed_function.x` | Vehicle-specific speed values for the piece-wise linear function. |
| `allowed_edges` | `List` of `Integer` | Optional | Values must be existing `edge_id` in the `edges` file | Indices of the edges that this vehicle type is allowed to take. If `null`, all edges are allowed (unless specificed in `restricted_edges`). |
| `restricted_edges` | `List` of `Integer` | Optional | Values must be existing `edge_id` in the `edges` file | Indices of the edges that this vehicle type cannot take. |


### Additional constraints

- There must be no edges with the same pair `(source, target)` (i.e., no parallel edges).
