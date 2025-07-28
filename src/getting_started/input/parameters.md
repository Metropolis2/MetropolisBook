# Parameters

**Table of Contents**

<!-- toc -->

The parameters of a METROPOLIS2's simulation are defined in a JSON file.

## Examples

Minimal working example:

```json
{
  "input_files": {
    "agents": "input/agents.parquet",
    "alternatives": "input/alternatives.parquet"
  },
  "period": [21600.0, 43200.0]
}
```

Complete example:

```json
{
  "input_files": {
    "agents": "input/agents.parquet",
    "alternatives": "input/alts.parquet",
    "trips": "input/trips.parquet",
    "edges": "input/edges.parquet",
    "vehicle_types": "input/vehicles.parquet",
    "road_network_conditions": "input/edge_ttfs.parquet"
  },
  "output_directory": "output/",
  "period": [0.0, 86400.0],
  "road_network": {
      "recording_interval": 50.0,
      "approximation_bound": 1.0,
      "spillback": true,
      "backward_wave_speed": 4.0,
      "max_pending_duration": 20.0,
      "constrain_inflow": true,
      "algorithm_type": "Best"
  },
  "learning_model": {
    "type": "Exponential",
    "value": 0.01
  },
  "init_iteration_counter": 1,
  "max_iterations": 2,
  "update_ratio": 1.0,
  "random_seed": 19960813,
  "nb_threads": 8,
  "saving_format": "Parquet",
  "only_compute_decisions": false
}
```

## Format

The following table describes all the possible key-value pairs in the parameters JSON file.

| Key | Value data type | Conditions  | Constraints | Description |
| --- | --------------- | ----------- | ----------- | ----------- |
| `input_files` | `InputFiles` | Mandatory | | [See below](#inputfiles) |
| `output_directory` | `Path` | Optional | | Directory where the output files of METROPOLIS2 will be stored. If omitted, the current working directory is used. If the given directory does not exist, it is created. |
| `period` | `Array` of two `Floats` | Mandatory | Length of the interval is positive | Time interval defining the domain of the travel-time functions. Also the departure-time period of the agents when the `dt_choice.period` parameter is omitted. |
| `init_iteration_counter` | `Integer` | Optional | Positive number | Initial iteration counter of the simulation. The iteration counter is only used in the output and in the function of some learning models. Default is `1`. |
| `max_iterations` | `Integer` | Optional | Positive number | Maximum number of iterations to run. Deault is to run a single iteration. |
| `road_network` | `RoadNetworkParameters` | Optional | | See below |
| `learning_model` | `LearningModel` | Optional | | [See below](#learningmodel) |
| `update_ratio` | `Float` | Optional | Between `0.0` and `1.0` | Share of agents (selected at random) that can update their choices at each iteration. Default is to allow all agents to update their choices at each iteration. |
| `random_seed` | `Integer` | Optional | Non-negative number | Random seed used for METROPOLIS2's random number generator. The only randomness in METROPOLIS2 is due to the `update_ratio` parameter. Default is to use entropy to generate a seed. |
| `nb_threads` | `Integer` | Optional | Non-negative number | Number of threads used for parallel computing. If `nb_threads` is `0`, all the available threads are used. Default value is `0`. |
| `saving_format` | `String` | Optional | Possible values: `"Parquet"`, `"CSV"` | Format used for METROPOLIS2's output files. Default is to use Parquet. |
| `only_compute_decisions` | `Boolean` | Optional | | If `true`, METROPOLIS2 only runs the demand model once then stops, returing the travel decisions of the agents. Default is `false`. |

### Path

The input files and output directory of the simulation are defined in the parameters JSON file as
paths.

Each path is a string representing either a relative path or an absolute path. *The relative paths
are interpreted as being relative to the directory where the parameters file is located.* In case of
issues when working with relative paths, try with absolute paths.

We recommend using slash `/` instead of backslash `\` in the paths.

### InputFiles

The value corresponding to the key `input_files` must be a JSON Object with the following key-value
pairs.

| Key | Value data type | Conditions  | Constraints | Description |
| --- | --------------- | ----------- | ----------- | ----------- |
| `agents` | `Path` | Mandatory | | Path to the input Parquet or CSV file with the agents to simulate. |
| `alternatives` | `Path` | Mandatory | | Path to the input Parquet or CSV file with the alternatives of the agents. |
| `trips` | `Path` | Optional | | Path to the input Parquet or CSV file with the trips of the alternatives. If omitted, no trip is simulated (the alternatives are no-trip alternatives). |
| `edges` | `Path` | Optional | | Path to the input Parquet or CSV file with the edges composing the road network. If omitted, there is no road network (not possible if there are some road trips). |
| `vehicle_types` | `Path` | Optional | | Path to the input Parquet or CSV file with the vehicle types. The path can be omitted if and only if there is no (i.e., `edges` and `vehicle_types` are either both valid or both empty). |
| `road_network_conditions` | `Path` | Optional | | Path to the input Parquet or CSV file with the edges' travel-time functions, to be used as starting network conditions. If omitted, the starting network conditions are assumed to be the free-flow conditions. |

### LearningModel

Let \\( \hat{T}\_{\kappa} \\) be the expected travel-time function for iteration \\( \kappa \\) and
let \\( T\_{\kappa} \\) be the simulated travel-time function at iteration \\( \kappa \\).

METROPOLIS2 supports the following learning models.

#### Linear learning model

\\[
    \hat{T}\_{\kappa+1} = \frac{1}{\kappa + 1} T\_{\kappa} + \frac{\kappa}{\kappa + 1}
    \hat{T}\_{\kappa},
\\]
such that, by recurrence,
\\[
    \hat{T}\_{\kappa+1} = \frac{1}{\kappa} \sum\_{i=0}^{\kappa} T\_{\kappa}.
\\]

JSON representation:

```json
{
  [...]
  "learning_model": {
    "type": "Linear"
  }
  [...]
}
```

#### Exponential learning model

\\[
    \hat{T}\_{\kappa+1} = \frac{\lambda}{a\_{\kappa+1}} T\_{\kappa} + (1 - \lambda)
    \frac{a\_{\kappa}}{a\_{\kappa+1}} \hat{T}\_{\kappa},
\\]
with
\\[
    a\_{\kappa} = 1 - (1 - \lambda)^{\kappa},
\\]
such that, by recurrence,
\\[
    \hat{T}\_{\kappa+1} = \frac{1}{a\_{\kappa}} \lambda \sum\_{i=0}^{\kappa} (1 - \lambda)^i T\_{\kappa}.
\\]

The parameter \\( \lambda \\) is called the smoothing factor.
With \\( \lambda = 0 \\), the exponential learning model is equivalent to a linear learning model
(see above).
With \\( \lambda = 1 \\), the predicted values for the next iteration are equal to the simulated
values, i.e., \\( \hat{T}\_{\kappa+1} = T\_{\kappa} \\).

The parameter \\( \lambda \\) must be between 0 and 1.

JSON representation (where "value" corresponds to the \\( \lambda \\) parameter):

```json
{
  [...]
  "learning_model": {
    "type": "Exponential",
    "value": 0.05
  }
  [...]
}
```

#### Unadjusted Exponential learning model

\\[
    \hat{T}\_{\kappa+1} = \lambda T\_{\kappa} + (1 - \lambda) \hat{T}\_{\kappa}.
\\]

The parameter \\( \lambda \\) must be between 0 and 1.

JSON representation (where "value" corresponds to the \\( \lambda \\) parameter):

```json
{
  [...]
  "learning_model": {
    "type": "ExponentialUnadjusted",
    "value": 0.05
  }
  [...]
}
```

#### Quadratic learning model

\\[
    \hat{T}\_{\kappa+1} = \frac{\sqrt{\kappa}}{\sqrt{\kappa} + 1} T\_{\kappa}
    + \frac{1}{\sqrt{\kappa} + 1} \hat{T}\_{\kappa}.
\\]

JSON representation:

```json
{
  [...]
  "learning_model": {
    "type": "Quadratic"
  }
  [...]
}
```

#### Genetic learning model

\\[
    \hat{T}\_{\kappa+1} = \big(T\_{\kappa} \cdot \hat{T}\_{\kappa}^{\kappa}\big)^{1 / (\kappa + 1)}.
\\]

JSON representation:

```json
{
  [...]
  "learning_model": {
    "type": "Genetic"
  }
  [...]
}
```


### RoadNetworkParameters

The `RoadNetworkParameters` value is an Object with the following key-value pairs:

| Key | Value data type | Conditions  | Constraints | Description |
| --- | --------------- | ----------- | ----------- | ----------- |
| `recording_interval` | `Float` | Mandatory | Positive number | Time interval, in seconds, between two breakpoints in the expected and simulated network conditions (the edge-level travel-time functions). |
| `approximation_bound` | `Float` | Optional | Non-negative number | When the difference between the minimum and the maximum value of a travel-time function is smaller than this bound, in seconds, the travel-time function is assumed to be constant. Default value is zero, i.e., there is no approximation. |
| `spillback` | `Boolean` | Optional | | If `true`, the number of vehicles on a road is limited by the total road length. Default is `true`. |
| `backward_wave_speed` | `Float` | Optional | Positive number | The speed, in meters per second, at which the holes created by a vehicle leaving a road is propagating backward (so that a pending vehicle can enter the road). By default, the holes propagate backward instantaneously. |
| `max_pending_duration` | `Float` | Mandatory if `spillback` is `true`, ignored otherwise | Positive number | Maximum amount of time, in seconds, that a vehicle can spend waiting to enter the next road. |
| `constrain_inflow` | `Boolean` | Optional | | If `true`, the bottlenecks limit the entry and exit flows of the road. If `false`, only the exit flow is limited (this is the behavior in MATSim). Default is `true`. |
| `algorithm_type` | `String` | Optional | Possible values: `"Best"`, `"Intersect"`, `"TCH"` | Algorithm type to use when computing the origin-destination travel-time functions. `"Intersect"` is recommended when the number of unique origins and destinations represent a relatively small part of the total number of nodes in the graph, but it consumes more memory. Default is `"Best"` (METROPOLIS2 tries to guess the fastest algorithm). |
