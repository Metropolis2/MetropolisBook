# Iteration Results

**Table of Contents**

<!-- toc -->


The file `iteration_results.parquet` (or `iteration_results.csv`) stores aggregate results for each
iteration run by the simulator.
The file is updated during the simulation, i.e., the results for an iteration are stored as soon as
this iteration ends.

The format of this file is described in the table below.
Many variables consist in four columns: the mean, standard-deviation, minimum and maximum of the
variable over the population.
A variable denoted as `var_*` in the table indicates that the results contain four variables:
`var_mean`, `var_std`, `var_min` and `var_max`.

| Column | Data type | Nullable | Description |
| ------ | --------- | -------  | ----------- |
| `iteration_counter` | `Integer` | No | Iteration counter. |
| `surplus_*` | `Float` | No | Surplus, or expected utility, from the alternative-choice model (mean, std, min and max over all agents). |
| `trip_alt_count` | `Integer` | Yes | Number of agents traveling (agents who chose an alternative with at least 1 trip). |
| `alt_departure_time_*` | `Float` | Yes | Departure time of the agent from the origin of the first trip, in number of seconds since midnight (mean, std, min and max over all agents traveling). |
| `alt_arrival_time_*` | `Float` | Yes | Arrival time of the agent at the destination of the last trip, in number of seconds since midnight (mean, std, min and max over all agents traveling). |
| `alt_travel_time_*` | `Float` | Yes | Total travel time of the agent for all the trips, in seconds (mean, std, min and max over all agents traveling). |
| `alt_utility_*` | `Float` | Yes | Simulated utility of the agent for the selected alternative, departure time and route (mean, std, min and max over all agents traveling). |
| `alt_expected_utility_*` | `Float` | Yes | Expected utility, or surplus, for the selected alternative (mean, std, min and max over all agents traveling). |
| `alt_dep_time_shift_*` | `Float` | Yes | By how much the selected departure time of the agent shifted from the previous iteration to the current iteration, in seconds (mean, std, min and max over all agents traveling who chose the same alternative for the previous and current iteration). |
| `alt_dep_time_rmse` | `Float` | Yes | By how much the selected departure time of the agent shifted from the previous iteration to the current iteration, in seconds (root-mean-squared error over all agents traveling who chose the same alternative for the previous and current iteration). |
| `road_trip_count` | `Integer` | Yes | The number of road trips among the simulated trips. |
| `nb_agents_at_least_one_road_trip` | `Integer` | Yes | The number of agents with at least one road trip in their selected alternative. |
| `nb_agents_all_road_trips` | `Integer` | Yes | The number of agents with only road trips in their selected alternative. |
| `road_trip_count_by_agent_*` | `Float` | Yes | Number of road trips in the selected alternative of the agents (mean, std, min and max over all agents with at least one road trip). |
| `road_trip_departure_time_*` | `Float` | Yes | Departure time from the origin of the trip, in number of seconds after midnight (mean, std, min and max over all road trips). |
| `road_trip_arrival_time_*` | `Float` | Yes | Arrival time from the origin of the trip, in number of seconds after midnight (mean, std, min and max over all road trips). |
| `road_trip_road_time_*` | `Float` | Yes | Time spent on the road, excluding the time spent in bottleneck queues, in seconds (mean, std, min and max over all road trips). |
| `road_trip_in_bottleneck_time_*` | `Float` | Yes | Time spent waiting in a queue at the entry bottleneck of an edge, in seconds (mean, std, min and max over all road trips). |
| `road_trip_out_bottleneck_time_*` | `Float` | Yes | Time spent waiting in a queue at the exit bottleneck of an edge, in seconds (mean, std, min and max over all road trips). |
| `road_trip_travel_time_*` | `Float` | Yes | Travel time of the trip, in seconds (mean, std, min and max over all road trips). |
| `road_trip_route_free_flow_travel_time_*` | `Float` | Yes | Travel time of the *selected route* under free-flow conditions, in seconds (mean, std, min and max over all road trips). |
| `road_trip_global_free_flow_travel_time_*` | `Float` | Yes | Travel time of the *fastest route* under free-flow conditions, in seconds (mean, std, min and max over all road trips). |
| `road_trip_route_congestion_*` | `Float` | Yes | Share of extra time spent in congestion over the route free-flow travel time, in seconds (mean, std, min and max over all road trips). |
| `road_trip_global_congestion_*` | `Float` | Yes | Share of extra time spent in congestion over the global free-flow travel time, in seconds (mean, std, min and max over all road trips). |
| `road_trip_length_*` | `Float` | Yes | Length of the route selected, in meters (mean, std, min and max over all road trips). |
| `road_trip_edge_count_*` | `Float` | Yes | Number of edges on the selected route (mean, std, min and max over all road trips). |
| `road_trip_utility_*` | `Float` | Yes | Simulated utility of the trip (mean, std, min and max over all road trips). |
| `road_trip_exp_travel_time_*` | `Float` | Yes | Expected travel time of the trip, at the time of departure (mean, std, min and max over all road trips). |
| `road_trip_exp_travel_time_rel_diff_*` | `Float` | Yes | Relative absolute difference between the trip's expected travel time and the trip's actual travel time (mean, std, min and max over all road trips). |
| `road_trip_exp_travel_time_abs_diff_*` | `Float` | Yes | Absolute difference between the trip's expected travel time and the trip's actual travel time, in seconds (mean, std, min and max over all road trips). |
| `road_trip_exp_travel_time_diff_rmse` | `Float` | Yes | Absolute difference between the trip's expected travel time and the trip's actual travel time, in seconds (root-mean-squared error over all road trips). |
| `road_trip_length_diff_*` | `Float` | Yes | Length of the selected route that was not selected during the previous iteration (mean, std, min and max over all road trips for agents who chose the same alternative for the previous and current iteration). |
| `virtual_trip_count` | `Integer` | Yes | The number of virtual trips among the simulated trips. |
| `nb_agents_at_least_one_virtual_trip` | `Integer` | Yes | The number of agents with at least one virtual trip in their selected alternative. |
| `nb_agents_all_virtual_trips` | `Integer` | Yes | The number of agents with only virtual trips in their selected alternative. |
| `virtual_trip_count_by_agent_*` | `Float` | Yes | Number of virtual trips in the selected alternative of the agents (mean, std, min and max over all agents with at least one virtual trip). |
| `virtual_trip_departure_time_*` | `Float` | Yes | Departure time from the origin of the trip, in number of seconds after midnight (mean, std, min and max over all virtual trips). |
| `virtual_trip_arrival_time_*` | `Float` | Yes | Arrival time from the origin of the trip, in number of seconds after midnight (mean, std, min and max over all virtual trips). |
| `virtual_trip_travel_time_*` | `Float` | Yes | Travel time of the trip, in seconds (mean, std, min and max over all virtual trips). |
| `virtual_trip_global_free_flow_travel_time_*` | `Float` | Yes | Minimum travel time possible for the trip, in seconds (mean, std, min and max over all road trips). Only relevant for time-dependent virtual trips. |
| `virtual_trip_global_congestion_*` | `Float` | Yes | Share of extra time spent in congestion over the global free-flow travel time, in seconds (mean, std, min and max over all road trips). Only relevant for time-dependent virtual trips. |
| `virtual_trip_utility_*` | `Float` | Yes | Simulated utility of the trip (mean, std, min and max over all virtual trips). |
| `no_trip_alt_count` | `Integer` | No | Number of agents not traveling (agents who chose an alternative with no trip). |
| `sim_road_network_cond_rmse` | `Integer` | Yes | Root-mean-squared error between the simulated edge-level travel-time function for the current iteration and the expected edge-level travel-time function for the previous iteration. The mean is taken over all edges and vehicle types. |
| `exp_road_network_cond_rmse` | `Integer` | Yes | Root-mean-squared error between the expected edge-level travel-time function for the current iteration and the expected edge-level travel-time function for the previous iteration. The mean is taken over all edges and vehicle types. |
