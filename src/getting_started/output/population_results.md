# Population Results

**Table of Contents**

<!-- toc -->


METROPOLIS2 returns up to three files for the results of the agents.

- `agent_results.parquet` (or `agent_results.csv`): results at the agent-level
- `trip_results.parquet` (or `trip_results.csv`): results at the trip-level
- `route_results.parquet` (or `route_results.csv`): details of the routes taken (for road trips)

## Agent results

| Column | Data type | Nullable | Description |
| ------ | --------- | -------  | ----------- |
| `agent_id` | `Integer` | No | Identifier of the agent (given in the input files). |
| `selected_alt_id` | `Integer` | No | Identifier of the alternative. |
| `expected_utility` | `Float` | No | Expected utility, or surplus, from the alternative-choice model. The exact formula and interpretation depends on the alternative-choice model of the agent. |
| `shifted_alt` | `Boolean` | No | Whether the agent selected alternative for the last iteration is different from the one selected at the previous iteration. |
| `departure_time` | `Float` | Yes | Departure time of the agent from the origin of the first trip (before the `origin_delay`), in number of seconds after midnight. If there is no trip for the selected alternative, the departure time is `null`. |
| `arrival_time` | `Float` | Yes | Arrival time of the agent at the destination of the last trip (after the trip's `stopping_time`), in number of seconds after midnight. If there is no trip for the selected alternative, the arrival time is `null`. |
| `total_travel_time` | `Float` | Yes | Total travel time of the agent for all the trips, in seconds. This does not include the `origin_delay` and the trips' `stopping_time`s. If there is no trip for the selected alternative, the total travel time is `null`. |
| `utility` | `Float` | No | Simulated utility of the agent for the selected alternative, departure time and route. |
| `alt_expected_utility` | `Float` | No | Expected utility, or surplus, for the selected alternative. The exact formula and interpretation depends on the departure-time choice model of this alternative. |
| `departure_time_shift` | `Float` | Yes | By how much the selected departure time of the agent shifted from the penultimate iteration to the last iteration. If there is no departure time for the selected alternative (or the previously selected alternative), the value is `null`. |
| `nb_road_trips` | `Integer` | No | The number of road trips in the selected alternative. |
| `nb_virtual_trips` | `Integer` | No | The number of virtual trips in the selected alternative. |

## Trip results

| Column | Data type | Nullable | Description |
| ------ | --------- | -------  | ----------- |
| `agent_id` | `Integer` | No | Identifier of the agent (given in the input files). |
| `trip_id` | `Integer` | No | Identifier of the trip (given in the input files). |
| `trip_index` | `Integer` | No | Index of the trip in the selected alternative's trip list (starting at 0). |
| `departure_time` | `Float` | No | Departure time of the agent from origin for this trip, in number of seconds after midnight. For the first trip, this is the departure time after the `origin_delay`. |
| `arrival_time` | `Float` | No | Arrival time of the agent at destination for this trip (before the trip's `stopping_time`), in number of seconds after midnight. |
| `travel_utility` | `Float` | No | Simulated travel utility of the agent for this trip. |
| `schedule_utility` | `Float` | No | Simulated schedule utility of the agent for this trip. |
| `departure_time_shift` | `Float` | Yes | By how much the departure time from origin for this trip shifted from the penultimate iteration to the last iteration. If there is no previous iteration, the value is `null`. |
| `road_time` | `Float` | Yes | For road trips, the time spent on the road, excluding the time spent in bottleneck queues, in seconds. For virtual trips, the value is `null`. |
| `in_bottleneck_time` | `Float` | Yes | For road trips, the time spent waiting in a queue at the entry bottleneck of an edge, in seconds. For virtual trips, the value is `null`. |
| `out_bottleneck_time` | `Float` | Yes | For road trips, the time spent waiting in a queue at the exit bottleneck of an edge, in seconds. For virtual trips, the value is `null`. |
| `route_free_flow_travel_time` | `Float` | Yes | For road trips, the travel time of the _selected route_ under free-flow conditions, in seconds. For virtual trips, the value is `null`. |
| `global_free_flow_travel_time` | `Float` | Yes | For road trips, the travel time of the _fastest route_ under free-flow conditions, in seconds. For virtual trips, the value is `null`. |
| `length` | `Float` | Yes | For road trips, the length of the route selected, in meters. For virtual trips, the value is `null`. |
| `length_diff` | `Float` | Yes | For road trips, the total length of the edges taken during the last iteration and that were not taken during the previous iteration, in meters. For virtual trips, the value is `null`. |
| `nb_edges` | `Integer` | Yes | For road trips, the number of edges on the selected route. For virtual trips, the value is `null`. |
| `pre_exp_departure_time` | `Float` | No | The expected departure time for this trip, before the simulation starts, in number of seconds since midnight. This is always equal to `departure_time` for the first trip of the agent. This can be different from `departure_time` if the previous trips' travel times were miss predicted. |
| `pre_exp_arrival_time` | `Float` | No | The expected arrival time for this trip, before the simulation starts, in number of seconds since midnight. |
| `exp_arrival_time` | `Float` | No | The expected arrival time for this trip, at the time the agent departs from the trip's origin, in number of seconds since midnight. This is different from `pre_exp_departure_time` if the trip's actual departure time is different from the one that was predicted before the start of the simulation. |

## Route results

| Column | Data type | Nullable | Description |
| ------ | --------- | -------  | ----------- |
| `agent_id` | `Integer` | No | Identifier of the agent (given in the input files). |
| `trip_id` | `Integer` | No | Identifier of the trip (given in the input files). |
| `trip_index` | `Integer` | No | Index of the trip in the selected alternative's trip list (starting at 0). |
| `edge_id` | `Integer` | No | Identifier of the edge (given in the input files). |
| `entry_time` | `Float` | No | Time at which the given agent entered the given edge, for their given trip, in number of seconds since midnight. |
| `exit_time` | `Float` | No | Time at which the given agent exited the given edge, for their given trip, in number of seconds since midnight. |
