# Agents

**Table of Contents**

<!-- toc -->

## CSV / Parquet representation

In METROPOLIS2, **agents** can choose between various **travel alternatives**, where each travel
alternative is composed of one or more **trips**.
Following this hierarchy, the population input is divided in three files:

- `agents.parquet` (or `agents.csv`)
- `alts.parquet` (or `alts.csv`)
- `trips.parquet` (or `trips.csv`)

### Agents

| Column | Data type | Conditions | Constraints | Description |
| ------ | --------- | ---------- | ----------- | ----------- |
| `agent_id` | `Integer` | Mandatory | No duplicate value, no negative value | Identifier of the agent (used to match with the alternatives and used in the output) |
| `alt_choice.type` | `String` | Optional | Possible values: `"Logit"`, `"Deterministic"` | Type of choice model for the choice of an alternative (See [Discrete choice model](#discrete-choice-model)). If `null`, the agent always chooses the first alternative. |
| `alt_choice.u` | `Float` | Mandatory if `alt_choice.type` is `"Logit"`, optional if `alt_choice.type` is `"Deterministic"`, ignored otherwise | Between `0.0` and `1.0` | Standard uniform draw to simulate the chosen alternative using [inverse transform sampling](https://en.wikipedia.org/wiki/Inverse_transform_sampling). For a deterministic choice, it is only used in case of tie and the default value is `0.0` (i.e., the first value is chosen in case of tie). |
| `alt_choice.mu` | `Float` | Mandatory if `alt_choice.type` is `"Logit"`, ignored otherwise | Positive number | Variance of the stochastic terms in the utility function, larger values correspond to "more stochasticity" |
| `alt_choice.constants` | `List` of `Float` | Optional if `alt_choice.type` is `"Deterministic"`, ignored otherwise | | Constant value added to the utility of each alternative. Useful to simulate a Multinomial Logit model (or any other discrete-choice model) with randomly drawn values for the stochastic terms. If the number of constants does not match the number of alternatives, the constants are cycled over. |

### Alternatives

| Column | Data type | Conditions | Constraints | Description |
| ------ | --------- | ---------- | ----------- | ----------- |
| `agent_id` | `Integer` | Mandatory | Value must exist in the `agents` file | Identifier of the agent |
| `alt_id` | `Integer` | Mandatory | No duplicate value over agents, no negative value | Identifier of the agent's alternative (used to match with the trips and used in the output) |
| `origin_delay` | `Float` | Optional | Non-negative number | Time in seconds that the agent has to wait between the chosen departure time and the start of the first trip. Default is zero. |
| `dt_choice.type` | `String` | Mandatory if the alternative has at least one trip, ignored otherwise | Possible values: `"Constant"`, `"Discrete"`, `"Continuous"` | Type of choice model for the departure-time choice (See [Departure-time choice](#departure-time-choice)). |
| `dt_choice.departure_time` | `Float` | Mandatory if `dt_choice.type` is `"Constant"`, ignored otherwise | Non-negative number | Departure time that will always be selected for this alternative |
| `dt_choice.period` | `List` of `Float` | Optional if `dt_choice.type` is `"Discrete"` or `"Continuous"`, ignored otherwise | The list must have exactly two values, both values must be positive, the second value must be larger than the first one, the period must be within the simulation period | Period of time `[t0, t1]` in which the departure time is chosen, where `t0` and `t1` are expressed in number of seconds after midnight. Only relevant for `"Discrete"` and `"Continuous"` departure-time model. If `null`, the departure time is chosen over the entire simulation period. |
| `dt_choice.interval` | `Float` | Mandatory if `dt_choice.type` is `"Discrete"`, ignored otherwise | Positive number | Time in seconds between two intervals of departure time. |
| `dt_choice.offset` | `Float` | Optional if `dt_choice.type` is `"Discrete"`, ignored otherwise | | Offset time (in seconds) added to the selected departure time. If it is zero (default), the selected departure times are always the center of the choice intervals. It is recommanded to set this value to a random uniform number in the interval `[-interval / 2, interval / 2]` so that the departure times are spread uniformly instead an interval. |
| `dt_choice.model.type` | `String` | Mandatory if `dt_choice.type` is `"Discrete"` or `"Continuous"`, ignored otherwise | Possible values: `"Logit"`, `"Deterministic"` (only for `"Discrete"`) | Type of choice model for departure-time choice. |
| `dt_choice.model.u` | `Float` | Mandatory if `dt_choice.type` is `"Discrete"` or `"Continuous"`, ignored otherwise | Between `0.0` and `1.0` | Standard uniform draw to simulate the chosen alternative using [inverse transform sampling](https://en.wikipedia.org/wiki/Inverse_transform_sampling). For a deterministic choice, it is only used in case of tie. |
| `dt_choice.model.mu` | `Float` | Mandatory if `dt_choice.model.type` is `"Logit"`, ignored otherwise | Positive number | Variance of the stochastic terms in the utility function, larger values correspond to "more stochasticity" |
| `dt_choice.model.constants` | `List` of `Float` | Optional if `dt_choice.model.type` is `"Deterministic"`, ignored otherwise | | Constant value added to the utility of each alternative. Useful to simulate a Multinomial Logit model (or any other discrete-choice model) with randomly drawn values for the stochastic terms. If the number of constants does not match the number of alternatives, the constants are cycled over. |
| `constant_utility` | `Float` | Optional | | Constant utility level added to the utility of this alternative. By default, the constant is zero. |
| `alpha` | `Float` | Optional | | Coefficient of degree 1 in the polynomial utility function of the total travel time of the alternative. The value must be expressed in *negative* utility unit per second of travel time, i.e., **positive values represent a utility loss.** This usually corresponds to the "value of travel time savings", divided by 3600. By default, the coefficient is zero. |
| `total_travel_utility.one` | `Float` | Optional | | Coefficient of degree 1 in the polynomial utility function of the total travel time of the alternative. The value must be expressed in utility unit per second of travel time. Compared to a value of time `VOT`, typically expressed as a cost in monetary units per hour, this coefficient should be `-VOT / 3600`. By default, the coefficient is zero. |
| `total_travel_utility.two` | `Float` | Optional | | Coefficient of degree 2 in the polynomial utility function of the total travel time of the alternative. The value must be expressed in utility unit per second of travel time. By default, the coefficient is zero. |
| `total_travel_utility.three` | `Float` | Optional | | Coefficient of degree 3 in the polynomial utility function of the total travel time of the alternative. The value must be expressed in utility unit per second of travel time. By default, the coefficient is zero. |
| `total_travel_utility.four` | `Float` | Optional | | Coefficient of degree 4 in the polynomial utility function of the total travel time of the alternative. The value must be expressed in utility unit per second of travel time. By default, the coefficient is zero. |
| `origin_utility.type` | `String` | Optional | Possible values: `"Linear"` | Type of utility function used for the schedule delay at origin (a function of the departure time from origin of the first trip, before the origin delay is elapsed). If `null`, there is no schedule utility at origin. |
| `origin_utility.tstar` | `String` | Mandatory if `origin_utility.type` is `"Linear"`, ignored otherwise |  | Center of the desired departure-time window from origin, in number of seconds after midnight. |
| `origin_utility.beta` | `String` | Optional if `origin_utility.type` is `"Linear"`, ignored otherwise |  | Penalty for departing earlier than the desired departure time, in utility units per second. **Positive values represent a utility loss.** If `null`, the value is zero. |
| `origin_utility.gamma` | `String` | Optional if `origin_utility.type` is `"Linear"`, ignored otherwise |  | Penalty for departing later than the desired departure time, in utility units per second. **Positive values represent a utility loss.** If `null`, the value is zero. |
| `origin_utility.delta` | `String` | Optional if `origin_utility.type` is `"Linear"`, ignored otherwise | Non-negative number | Length of the desired departure-time window from origin, in seconds. The window is then `[tstar - delta / 2, tstar + delta / 2]`. If `null`, the value is zero. |
| `destination_utility.type` | `String` | Optional | Possible values: `"Linear"` | Type of utility function used for the schedule delay at destination (a function of the arrival time at destination of the last trip, after the trip's stopping time elapses). If `null`, there is no schedule utility at destination. |
| `destination_utility.tstar` | `String` | Mandatory if `destination_utility.type` is `"Linear"`, ignored otherwise |  | Center of the desired arrival-time window at destination, in number of seconds after midnight. |
| `destination_utility.beta` | `String` | Optional if `destination_utility.type` is `"Linear"`, ignored otherwise |  | Penalty for arriving earlier than the desired arrival time, in utility units per second. **Positive values represent a utility loss.** If `null`, the value is zero. |
| `destination_utility.gamma` | `String` | Optional if `destination_utility.type` is `"Linear"`, ignored otherwise |  | Penalty for arriving later than the desired arrival time, in utility units per second. **Positive values represent a utility loss.** If `null`, the value is zero. |
| `destination_utility.delta` | `String` | Optional if `destination_utility.type` is `"Linear"`, ignored otherwise | Non-negative number | Length of the desired arrival-time window at destination, in seconds. The window is then `[tstar - delta / 2, tstar + delta / 2]`. If `null`, the value is zero. |
| `pre_compute_route` | `Boolean` | Optional | | When this alternative is selected, if `true` (default), the routes (for all road trips of this alternative) are computed before the day start. If `false`, the routes are computed when the road trip start which means that the actual departure time is used (not the expected one). Leaving this to `true` is recommanded to make the simulation faster. |


### Trips

| Column | Data type | Conditions | Constraints | Description |
| ------ | --------- | ---------- | ----------- | ----------- |
| `agent_id` | `Integer` | Mandatory | Value must exist in the `agents` file | Identifier of the agent |
| `alt_id` | `Integer` | Mandatory | Value must exist in the `alternatives` file | Identifier of the alternative |
| `trip_id` | `Integer` | Mandatory | No duplicate value over alternatives, no negative value | Identifier of the alternative's trip (used in the output) |
| `class.type` | `String` | Mandatory | Possible values: `"Road"`, `"Virtual"` | Type of the trip (See [Trip types](#trip-types)) |
| `class.origin` | `Integer` | Mandatory if `class.type` is `"Road"`, ignored otherwise | Value must match the id of a node in the road network | Origin node of the trip. |
| `class.destination` | `Integer` | Mandatory if `class.type` is `"Road"`, ignored otherwise | Value must match the id of a node in the road network | Destination node of the trip. |
| `class.vehicle` | `Integer` | Mandatory if `class.type` is `"Road"`, ignored otherwise | Value must match the id of a vehicle type | Identifier of the vehicle type to be used for this trip. |
| `class.route` | `List` of `Integer` | Optional if `class.type` is `"Road"`, ignored otherwise | All values must match the id of an edge in the road network | Route to be followed by the agent when taking this trip. If `null`, the fastest route at the time of departure is taken. |
| `class.travel_time` | `Float` | Optional if `class.type` is `"Virtual"`, ignored otherwise | Non-negative number | Exogenous travel time of this trip, in seconds. If `null`, the travel time is zero. |
| `stopping_time` | `Float` | Optional | Non-negative number | Time in seconds that the agent spends at the trip's destination before starting the next trip. In an activity-based model, this would correspond to the activity duration. |
| `constant_utility` | `Float` | Optional | | Constant utility level added to the utility of this trip. By default, the constant is zero. |
| `alpha` | `Float` | Optional | | Coefficient of degree 1 in the polynomial utility function of the travel time of this trip. The value must be expressed in negative utility unit per second of travel time, i.e., **positive values represent a utility loss.** This usually corresponds to the "value of travel time savings", divided by 3600. By default, the coefficient is zero. |
| `travel_utility.one` | `Float` | Optional | | Coefficient of degree 1 in the polynomial utility function of the travel time of this trip. The value must be expressed in utility unit per second of travel time. By default, the coefficient is zero. |
| `travel_utility.two` | `Float` | Optional | | Coefficient of degree 2 in the polynomial utility function of the travel time of this trip. The value must be expressed in utility unit per second of travel time. By default, the coefficient is zero. |
| `travel_utility.three` | `Float` | Optional | | Coefficient of degree 3 in the polynomial utility function of the travel time of this trip. The value must be expressed in utility unit per second of travel time. By default, the coefficient is zero. |
| `travel_utility.four` | `Float` | Optional | | Coefficient of degree 4 in the polynomial utility function of the travel time of this trip. The value must be expressed in utility unit per second of travel time. By default, the coefficient is zero. |
| `schedule_utility.type` | `String` | Optional | Possible values: `"Linear"` | Type of utility function used for the schedule delay at destination (a function of the arrival time at destination of this trip). If `null`, there is no schedule utility for this trip. |
| `schedule_utility.tstar` | `Float` | Mandatory if `schedule_utility.type` is `"Linear"`, ignored otherwise |  | Center of the desired arrival-time window at destination, in number of seconds after midnight. |
| `schedule_utility.beta` | `Float` | Optional if `schedule_utility.type` is `"Linear"`, ignored otherwise |  | Penalty for arriving earlier than the desired arrival time, in utility units per second. **Positive values represent a utility loss.** If `null`, the value is zero. |
| `schedule_utility.gamma` | `Float` | Optional if `schedule_utility.type` is `"Linear"`, ignored otherwise |  | Penalty for arriving later than the desired arrival time, in utility units per second. **Positive values represent a utility loss.** If `null`, the value is zero. |
| `schedule_utility.delta` | `Float` | Optional if `schedule_utility.type` is `"Linear"`, ignored otherwise | Non-negative number | Length of the desired arrival-time window at destination, in seconds. The window is then `[tstar - delta / 2, tstar + delta / 2]`. If `null`, the value is zero. |


### Additional constraints

- At least one alternative in `alts.parquet` for each `agent_id` in `agents.parquet`.
- For each trip in `trips.parquet`, a corresponding pair `(agent_id, alt_id)` must exist in
  `alts.parquet`.

## Modeling considerations

### No-trip alternatives

It is not mandatory to have at least one trip for each alternative.
When there is an alternative with no trip, the agent will simply not travel during the simulated
day.
The `constant_utility` parameter can be used at the alternative-level to set the utility of the
alternative.

### Discrete Choice Model

In METROPOLIS2, there are two types of discrete choice models: **Deterministic** and **Logit**.

#### Deterministic choice model

With a deterministic choice model, the alternative with the largest utility is chosen.

A deterministic choice model can have up to two parameters: `u` and `constants`.
The parameter `u` must be a `float` between `0.0` and `1.0`.
This parameter is only used in case of tie (there are two or more alternatives with the exact same
utility).
If there are two such alternatives, the first one is chosen if `u <= 0.5`; the second one is chosen
otherwise.
If there are three such alternatives, the first one is chosen is `u <= 0.33`; the second one is
chosen if `0.33 < u <= 0.67`; and the third one is chosen otherwise.
And so on for 4 or more alternatives.

The parameter `constants` is a list of values which are added to the utility of each alternative
before the choice is computed.
If the number of constants does not match the number of alternatives, the values are cycled over.
For example, assume that there are three alternatives with utility `[1.0, 2.0, 3.0]`.
If the given constants are `[0.1, 0.5]`, then the final utilities used to make the choice will be:
`[1.1, 2.5, 3.1]` (the first constant is used twice).
If the given constants are `[0.1, 0.5, 0.7, 0.9]`, then the final utilities used to make the choice
will be: `[1.1, 2.5, 3.7]` (the last constant is ignored).
A few considerations should be noted:

- The constants can be used to represent the draws of random perturbations in a discrete-choice
  model. For example, to simulate a Probit in METROPOLIS2, you can draw as many Gaussian random
  variables as there are alternatives and put the draws in the `constants` parameter.
- For travel alternatives (`alt_choice.type`), it is recommended to add the constant value to the
  utility of the alternative directly (`constant_utility` parameter). This is not possible however
  when using a deterministic choice model for the departure-time choice (`dt_choice.model.type`).
- It is recommended to set as many constants as there are alternatives to prevent confusion.
- In the output, the constant value for the selected alternative is not return in the `utility` of
  this alternative. It is part of the `expected_utility` however.


#### Logit choice model

With a Logit choice model, alternatives are chosen with a probability given by the Multinomial Logit
formula:

\\[
    p\_j = \frac{e^{V\_j / \mu}}{\sum_{j'} e^{V\_{j'} / \mu}}.
\\]

A Logit choice model has two parameters:

- `u` (`float` between `0.0` and `1.0`)
- `mu` (`float` larger than `0.0`)

The parameter `mu` represents the variance of the extreme-value distributed random terms in the
Logit theory.

The parameter `u` indicates how the alternative is chosen from the Logit probabilities (See [Inverse
transform sampling](https://en.wikipedia.org/wiki/Inverse_transform_sampling)).

### Departure-Time Choice

There are three possible types for the departure-time choice of an alternative: Constant, Discrete,
Continuous.

#### Constant

There is no choice, the departure time for the alternative is always equal to the given
departure-time (`dt_choice.departure_time`).

The `expected_utility` of this alternative is equal to the utility computed for this departure time,
using the expected travel time.

#### Discrete

The agent chooses a departure-time among various departure-time intervals, of equal length.

The choice intervals depends on the parameters `dt_choice.period` and `dt_choice.interval`.
For example, if the period is [08:00, 09:00] and the interval is 20 minutes, the choice intervals
are [08:00, 08:20], [08:20, 08:40] and [08:40, 09:00].
The choice is then computed based on the expected utilities at the center of the intervals (i.e., at
08:10, 08:30 and 08:50 in the example), using a [Discrete choice model](#discrete-choice-model).

The `dt_choice.offset` parameter can be used to shift the selected departure time.
For example, if the agent selects the interval [08:20, 08:40] and the offset is `-120`, the selected
departure time will be 08:28 (the center 08:30, minus 2 minutes for the offset).
It is recommended to set the offset value to uniform draws in the interval `[-interval_length / 2,
interval_length / 2]` so that the departure times are uniformly spread in the chosen departure
time intervals.

#### Continuous

A departure time is chosen with a probability given by the Continuous Logit formula:

\\[
    p(t) = \frac{e^{V(t) / \mu}}{\int\_{t\_0}^{t\_1} e^{V(\tau) / \mu} \text{d} \tau},
\\]

where \\( [t\_0, t\_1] \\) is the period of the departure-time choice (parameter
`dt_choice.period`).

The only possible choice model for a continuous departure-time choice is `"Logit"`, with parameters
`u` and `mu`.

### Trip types

There are two types of trips: road and virtual.

#### Road trips

Road trips represent a trip on the road network from a given origin to a given destination, using a
given vehicle type.
The parameter `class.route` can be used to force the vehicle to follow a route.

#### Virtual trips

Virtual trips represent a trip with an exogenous travel time (independent of the other agents'
choices).
