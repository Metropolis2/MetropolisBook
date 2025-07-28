# Input

The main input file of METROPOLIS2 is a [JSON file defining the parameters](parameters.html) of the simulation.
This file gives the path to the other input files to be read by METROPOLIS2.
These input files can be in either Parquet or CSV format and they are divided two categories:

+ [Population input](agents.html): the collection of agents, with their travel alternatives to
  simulate.
+ [Road network](road-network.html): the definition of the infrastructure that can be used by road
  vehicles.
