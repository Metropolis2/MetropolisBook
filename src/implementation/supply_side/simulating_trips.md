# Simulating Trips

> WARNING. This chapter is not completely up to date with the last version (the spillback effect is
> not discussed).

Only travel alternatives with at least one road trip are simulated.
The travel alternatives with only virtual trips can be simulated outside of the supply model.

From the demand model, we know the departure time from the origin of the first trip of the travel
alternative.

The trip is simulated by executing timestamped events.

A road event is composed of the following variables:

- `agent`: Index of the agent simulated.
- `alternative`: Description of the alternative to simulate.
- `at_time`: Execution time of the event.
- `trip_position`: Index of the current trip in the alternative.
- `edge_position`: Index of the current edge in the trip's route.
- `route`: Current trip's route being followed.
- `current_event`: Description of the current edge entry event (edge entry time, edge exit
  bottleneck entry time, etc.).
- `event_type`: Type of the event.

There are 7 types of events:

- `BeginsVirtualTrip`: the agent starts a virtual trip.
- `LeavesOrigin`: the agent leaves the origin of a trip.
- `EntersInBottleneck`: the agent enters the in-bottleneck of an edge.
- `EntersRoadSegment`: the agent enters the running part of an edge.
- `EntersOutBottleneck`: the agent enters the out-bottleneck of an edge.
- `ExitsEdge`: the agent exits an edge.
- `ReachesDestination`: the agent reaches the destination of a trip.

At the start of the supply model, an event is created for each simulated travel alternative.
The event type is `BeginsVirtualTrip` if the first trip of the event is virtual, otherwise, the
event type is `LeavesOrigin`.
The execution time of the event is set to the chosen departure time, plus the origin delay.

## BeginsVirtualTrip

When a `BeginsVirtualTrip` event is executed:

- Compute the trip travel time using the input TTF of the virtual trip.
- Store the departure time, arrival time and utility of the trip.
- If this trip is not the last trip of the trip chain, create a new `BeginsVirtualTrip` or
  `LeavesOrigin` event (according to the next trip type) and set the event execution time to the
  arrival time of the current trip plus the stopping time.
- If this trip is the last trip of the trip chain, compute and store agent-level results (global
  arrival time, total utility and travel time, etc.).

## LeavesOrigin

When a `LeavesOrigin` event is executed:

- Store the departure time of the trip.
- Compute the fastest route between origin and destination and expected arrival time at destination,
  given the departure time from origin.
- Set the `route` variable to the computed route and set the `edge_position` variable to `0`.
- Store the expected arrival time at destination.
- Compute and store the route free-flow travel time, route length and global free-flow travel time.
- Set the next event to `EntersInBottleneck` and execute it immediately.

## EntersInBottleneck

When a `EntersInBottleneck` event is executed:

- Set the current edge according to the `route` and `edge_position` values.
- Record the entry time on the edge's entry bottlenec.
- Set the type of the next event to `EntersRoadSegment`.
- Check the status of the bottleneck: if it is open, the next event can be executed immediately, if
  it is close the event will be executed when the bottleneck open again (the bottleneck entity is
  responsible for executing the next event).

## EntersRoadSegment

When a `EntersInBottleneck` event is executed:

- Record the entry time on the edge's road segment.
- Compute the travel time on the edge's road segment given the current density of vehicle on this
  segment and the vehicle of the road trip.
- Set the type of the next event to `EntersOutBottleneck`.
- Set the execution time of the next event to the current time plus the travel time on the road
  segment.

## EntersOutBottleneck

When a `EntersOutBottleneck` event is executed:

- Record the entry time on the edge's exit bottleneck.
- Set the type of the next event to `ExitsEdge`.
- Check the status of the bottleneck: if it is open, the next event can be executed immediately, if
  it is close the event will be executed when the bottleneck open again (the bottleneck entity is
  responsible for executing the next event).

## ExitsEdge

When a `ExitsEdge` event is executed:

- Record the exit time on the edge.
- Store the edge taken in the results, with its entry time.
- Increment the road time, in-bottleneck time and out-bottleneck time of the current trip according
  to the recorded timings for the edge taken.
- If the current edge is the last edge of the route, then the destination is reached so the next
  event type is set to `ReachesDestination` and the next event is executed immediately.
- If the current edge is not the last edge of the route, the `edge_position` variable is incremented
  by 1, the next event type is set to `EntersEdge` and the next event is executed immediately.

## ReachesDestination

When a `ReachesDestination` event is executed:

- Compute the total travel time of the trip.
- Store
- Store the arrival time and utility of the trip.
- If this trip is not the last trip of the trip chain, create a new `BeginsVirtualTrip` or
  `LeavesOrigin` event (according to the next trip type) and set the event execution time to the
  arrival time of the current trip plus the stopping time.
- If this trip is the last trip of the trip chain, compute and store agent-level results (global
  arrival time, total utility and travel time, etc.).
