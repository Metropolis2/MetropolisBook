# Simulating road tolls

The current version of METROPOLIS2 does not allow to simulate road tolls.
This limitation is due to the routing algorithm which cannot consider tolls or any other criteria
different from travel time.

This limitation might be lifted in a future version of METROPOLIS2.
In the meantime, some limited forms of tolls can be simulated, by leveraging the flexible
alternative choice model of METROPOLIS2.
The basic principle relies on defining two alternatives for the agents: an alternative where they
pay the toll and can take the tolled roads and an alternative where they do not pay the toll but are
limited to the non-tolled roads.
In this way, the choice between taking a tolled road or not is made at the alternative-choice level
and not at the route-choice level.

## Route Choice: Two parallel roads

Consider a simple road network with two parallel roads:

- North road (`id` 1, toll of $2)
- South road (`id` 2, no toll)

To reach their destination, the agents can either take the North road and pay a $2 toll or take the
South road without paying a toll.
This route choice can be simulating in METROPOLIS2 by considering two alternatives for any agent:

- Alternative 1 (toll alternative): `constant_utility` is set to `-2` (the toll amount), there is a
  single `"Road"` trip with `class.route` value set to `[1]` (i.e., the agent is forced to take the
  North road).
- Alternative 2 (no-toll alternative): `constant_utility` is set to `0`, there is a single `"Road"`
  trip with `class.route` value set to `[2]` (i.e., the agent is forced to take the South road).

Then, if the alternative-choice model (`alt_choice.model`) is set to `"Deterministic"`, the agents
will choose the choice that minimizes their utility between taking the North road and pay a $2 toll
or taking the South road without any toll, considering the expected travel time of either road.

The following files define a simulation with a single agent choosing between a tolled road and a
non-tolled road.

`parameters.json`
```json
{
  "period": [
    0,
    3600
  ],
  "road_network": {
    "recording_interval": 60,
    "spillback": false,
    "max_pending_duration": 0.0
  },
  "learning_model": {
    "type": "Exponential",
    "value": 0.01
  },
  "max_iterations": 1,
  "input_files": {
    "agents": "agents.csv",
    "alternatives": "alts.csv",
    "trips": "trips.csv",
    "edges": "edges.csv",
    "vehicle_types": "vehicles.csv"
  },
  "output_directory": "output",
  "saving_format": "CSV"
}
```

`agents.csv`
```csv
agent_id,alt_choice.type
0,Deterministic
```

`alts.csv`
```csv
agent_id,alt_id,dt_choice.type,dt_choice.departure_time,constant_utility,total_travel_utility.one
0,0,Constant,0.0,-2.0,-0.01
0,1,Constant,0.0,0.0,-0.01
```

`trips.csv`
```csv
agent_id,alt_id,trip_id,class.type,class.origin,class.destination,class.vehicle,class.route
0,0,0,Road,1,3,1,1
0,1,1,Road,1,3,1,2
```

`edges.csv`
```csv
edge_id,source,target,speed,length,lanes,bottleneck_flow
1,1,3,20.0,10000.0,1.0,0.5
2,1,2,10.0,10000.0,1.0,0.25
3,2,3,10.0,0.0,1.0,
```

`vehicles.csv`
```csv
vehicle_id,headway,pce
1,8.0,1.0
```

> NOTE. The `class.route` parameter is not supported for the CSV file format as lists are not
> supported. In this case however, the two routes consist in a single edge so they can be added to
> the CSV file without relying on lists.

> NOTE. The `edges.csv` file has three edges, even though the road network is supposed to have only
> two edges. This is because parallel edges are not supported in METROPOLIS2 (see
> [Parallel edges](./parallel_edges.md) for more).

There is an alternative way to simulate the same simulation without relying on the `class.route`
parameter.
This can be done by using the road restrictions feature of METROPOLIS2 to prevent the agents who did
not pay the toll from taking the tolled road.
Compared to the previous simulation files, the following changes must be made.

First, the `trips.csv` must specify a different vehicle type for the trip of the toll alternative
(vehicle type with `id` 1) and the no-toll alternative (vehicle type with `id` 2).
The `class.route` parameter can also be removed.

```csv
agent_id,alt_id,trip_id,class.type,class.origin,class.destination,class.vehicle
0,0,0,Road,1,3,1
0,1,1,Road,1,3,2
```

Then, the `vehicles.csv` file must define the two vehicle types with the road restriction:

`vehicles.csv`
```csv
vehicle_id,headway,pce,restricted_edges
1,8.0,1.0,
2,8.0,1.0,1
```

The two vehicle types are identical but the vehicle type of `id` 2 cannot take the edge of `id` 1
(the tolled North road).

> NOTE. Like the `class.route` parameter, the `restricted_edges` parameter in `vehicles.csv` is not
> supported for the CSV format as it expects a list. But, again, we only need to specify one edge id
> in the list in this example which is the only case where `restricted_edges` can be specified with
> the CSV format.

> NOTE. Cordon tolls can be simulated simulated easily using the same principle:
> 1. Create two alternatives for each agent (the first one with the toll paid and the second one
>    without any toll paid)
> 2. Create two different vehicle types (the first one that is allowed everywhere on the road
>    network and the seconde one that cannot access any edge inside the cordon area)
> 3. Create trips for the first alternative using the first vehicle type and trips for the second
>    alternative using the second vehicle type.

> NOTE. It is possible to simulate two or more tolled roads, with different toll amounts.
> With just two tolled roads, 4 alternatives and 4 vehicle types must be created: (i) paying no toll
> and taking no tolled road, (ii) paying the first toll amount and being able to take the first
> tolled road, (iii) paying the second toll amount and being able to take the second tolled road and
> (iv) paying both toll amounts and being able to take both tolled roads.
> As the number of tolled roads increases, this solution becomes very complex and computationally
> intensive.
> With `n` tolled roads, the number of alternatives and vehicle types to include is `2^n`.

## Mode choice

Even though the alternative choice model was used as a kind of route choice model in the previous
example, this does not mean that simulating tolls is incompatible with simulating a mode choice
model.
Indeed, the previous example can be completed by adding a third alternative with a `"Virtual"` trip
to represent, for example, a public-transit trip.
In this case, the agent would choose the alternative maximizing his / her utility between taking the
car with the tolled road, taking the car without the tolled road and taking public transit.

Using a `"Logit"` alternative choice model in this case does not really make sense because the IID
assumption is not satisfied.
If you nevertheless want to simulate a binary Logit model between car and public transit, where the
car mode can be either with or without the toll, this is possible in the following way:

1. Draw two random values with Gumbel distribution, one for car and one for public transit.
2. Add the car random value to the `constant_utility` parameter for the two car alternatives (toll
   and no-toll).
3. Add the public-transit random value to the `constant_utility` parameter for the public-transit
   alternative.
4. Set the alternative choice model to `"Deterministic"`.

If the number of agents is very large (each with their own random values), this methodology is
equivalent to simulating a binary Logit model between car and public transit, with a deterministic
choice between toll and no-toll for the car mode.
See [Discrete Choice Model](/getting_started/input/agents.html#discrete-choice-model) for more.

## Departure-time choice

So far, we have only considered a `"Constant"` departure time.
When a Continuous Logit departure-time choice model is used, the results are not consistent with the
decision tree of the agents.
The reason is that the route choice decision is supposed ot be after the departure-time choice
decision in the decision tree but, in METROPOLIS2, the alternative choice decision is above the
departure-time choice decision.

In principle, the agents should choose their departure time knowing the route decision (including
the toll decision) that they would do given any departure time.
Therefore, the expected utility (logsum) from the deparure-time choice model should look like

\\[
    \ln \int\_\tau e^{\max(V^{\text{toll}}(\tau), V^{\text{no-toll}}(\tau))} \text{d} \tau.
\\]

However, when the toll decision is simulating using the two-alternative specification proposed
above, the expected utility from the combined alternative and departure-time choice looks like

\\[
    \max\left(\ln \int\_\tau e^{V^{\text{toll}}(\tau)} \text{d} \tau, \ln \int\_\tau e^{V^{\text{no-toll}}(\tau)} \text{d} \tau\right).
\\]

The two formula are not equivalent in the general case.
Simulating tolls is thus not compatible with the `"Continuous"` departure-time model (unless
one is ready to assume a different decision tree).

The `"Discrete"` departure-time model is compatible with tolls if a `"Deterministic"` choice model
is used.
In particular, tolls are compatible with a Multinomial Logit model for both departure-time choice
and mode-choice, if the random epsilon values are drawn.
See [Inverse transform sampling Logit or simulated Logit](./logit_u_vs_epsilon.md) for more.
