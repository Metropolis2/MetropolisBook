# Trips

**<p style="color:red;">SOME INFORMATIONS ON THIS PAGE MIGHT BE OUTDATED</p>**

In Metropolis, a trip is a sequence of one or more leg.
The trip consists in traveling sequentially through all the legs, in the given order.

**Table of Contents**

<!-- toc -->

## Timings

The timings of a trip are as follows:

- Given the departure time of the trip, the first leg starts after the given **origin delay** has
  elapsed.
- When a leg starts, the agent immediately enters the road network at origin (for road legs) or
  wait for the given travel time (for virtual legs).
- As soon as the agent reaches the destination of the leg (for road legs) or waited for the given
  travel time (for virtual legs), the agent waits for the given **stopping time** of the leg then
  starts the next leg (if any).

To understand how schedule utility is computed, it is important to understand how departure times
and arrival times are defined:

- The *departure time of the trip* is defined as the time at which the origin delay starts.
- The *departure time of a leg* is defined as the time at which leg starts (i.e., end of the origin
  delay for the first leg and end of the stopping time of the previous leg for all the other legs).
- The *arrival time of a leg* is defined as the time at which the stopping time of the leg starts.
- The *arrival time of the trip* is defined as the time at which the stopping time of the last leg
  elapsed.

## Trip utility

The total utility of a trip is the sum of five components:

- The *schedule utility at origin*, a function of the departure time of the trip.
- The *schedule utility at destination*, a function of the arrival time of the trip.
- The *total travel utility*, a function of the sum of the travel time for each leg of the trip.
- The *schedule utility of each leg*, a function of the arrival time of each leg.
- The *travel utility of each leg*, a function of the travel time of each leg.

> Note. The origin of a trip does not have to be equal to the destination of the previous trip and
> the vehicle type of a trip does not have to be equal to the vehicle type of the previous trip,
> i.e., agents can "teleport" and switch vehicles.

### Travel utility

A `TravelUtility` is an Object representing a function that yields a utility level given a travel
time.

Currently, there is only one type of travel-utility function supported: a polynomial function of
degree 4.
Constant, linear, quadratic and cubic functions can be represented by setting the higher-order
coefficients to zero.

### Schedule utility

A `ScheduleUtility` is an Object representing a function that yields a utility level given a
departure or arrival time.

Currently, there are two types of schedule-utility function:

- **None**: The utility is always zero.
- **AlphaBetaGamma**: The utility is computed using Arnott, de Palma, Lindsey's alpha-beta-gamma
  model.

**None** is the default so if the `ScheduleUtility` is not specified, it is assumed to be zero.
To represent a `ScheduleUtility` of type **None**, use

Given a departure or arrival time `t`, the schedule utility is (note the minus to convert from cost
to utility):

- `-beta * (t_star_low - t)` if `t < t_star_low`
- `-gamma * (t - t_star_high)` if `t > t_star_high`
- `0` otherwise
