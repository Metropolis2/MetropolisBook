# Metropy User Guide

Metropy is a Python command line tool to process the input / output data of the Rust simulator.

Metropy can run many operations like:

- importing a road network from OpenStreetMap data,
- generating trips from an origin-destination matrix,
- computing the walking distance of a set of trips,
- building a macroscopic fundamental graph from the results.


## Requirements ☑️

- Recent [Python](https://www.python.org/downloads/) version (3.11+).
- [Git](https://git-scm.com/downloads) or [GitHub Desktop](https://desktop.github.com/download/)
- [QGIS](https://qgis.org/download/) with parquet support (QGIS 3.22+, GDAL 3.5+),
  optional (only used to visualize spatial data).


## Installation 🔧

1. Clone the [metropy GitHub repository](https://github.com/Metropolis2/metropy) with the command
   `git clone https://github.com/Metropolis2/metropy` or directly from GitHub Desktop.
2. Install the python packages listed in `requirements.txt`. The recommended way is to install
   [virtualenv](https://virtualenv.pypa.io/en/latest/installation.html) and run the following
   commands from the `metropy` directory:
   ```shell
   $ virtualenv env
   $ source venv/bin/activate
   $ pip install -r requirements.txt
   ```

To check that metropy has been installed correctly, you can run `python -m metropy --help` from the
`metropy` directory.


## How to use 🤷‍♂️

Before running metropy, you need to create a [TOML](https://toml.io/) configuration file that will
dictate how the simulation is generated (which area? what data is used to import the population?
which modes are available?, etc.).
All the possible parameter values in the configuration file are detailed on the
[Configuration](configuration.md) page.

When your configuration is ready, simply run the command:
```shell
$ python -m metropy my-config.toml
```
This will run all the steps which are required to generate the simulation's input files.

If you change some parts of the configuration and the run the command again, metropy will only
execute the steps which need to be executed again (e.g., the road network is not imported again if
you only changed the origin-destination matrix).


## Next steps 🧭

This user guide contains a detailed description
- the [Steps](steps.md) that metropy can run,
- the [Configuration](configuration.md) parameters,
- the [Files](files.md) generated.

If you prefer to learn through complete examples, have a look at [Case Study 1](chambery.md) (detailed
simulation generation with synthetic population for a small-size French city, Chambéry) or Case
Study 2 (TO BE DONE).


## Advanced use ⚙️

Metropy generates the simulation's input files by executing sequentially several "Steps", which are
detailed on the [Steps](steps.md) page.
The execution order is computed automatically so that no step is executed before its prerequisite
steps are executed (e.g., the walking distance is not computed before the walking network is
imported).

If you don't want to generate all input files and only require a specific step to be run, you can do
so using the optional `--step` argument.
For example, if you run the command:
```shell
$ python -m metropy my-config.toml --step simulation-area
```
metropy will only run the step `osm-import` and all the prerequisite steps then stop.


## Getting help 🛟

Although metropy tries to be as reliable and universal as possible, various issues can arise when
running metropy due to the complexity of the process involved and the variety of datasets around the
world.
Many error messages have been included in the library to explain as clearly the issues that might
have occurred.

If you found a bug or if there is a problem that you cannot fix, feel free to open an issue on the
[GitHub repository](https://github.com/Metropolis2/metropy/issues).
