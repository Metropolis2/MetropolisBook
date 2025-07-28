# Parallel edges

One limitation of the routing algorithm of METROPOLIS2 is that it cannot handle parallel edges
properly.
Two edges are parallel if they both have the same source and target node.

If METROPOLIS2 is run with parallel edges, a warning will be shown and the simulator will have an
unpredictable behavior (i.e., it might crash or the results might be incorrect).

If you want to run METROPOLIS2 using a road network with parallel edges it is nevertheless possible
using the following workaround.

The workaround consists in creating a dummy edge with null length so that the two edges are no
longer parallel, without affecting the shortest paths.
More precisely, let say that you want to simulate a road network with two parallel edges, with id 1
and 2, from source node 1 to target node 3.
If you create a dummy edge, with id 3 and length 0, going from source node 2 to target node 3 and if
you set the target node of edge 2 to 2 (instead of 3), then the you get a road network that is
topologically identical but without any parallel edges.

Therefore, if your road network is defined by the following edges in `edges.csv`:

```csv
edge_id,source,target,speed,length,lanes,bottleneck_flow
1,1,3,20.0,10000.0,1.0,0.5
2,1,3,10.0,10000.0,1.0,0.25
```

Then, you should use the following modified `edges.csv` file to simulate properly this road network
with METROPOLIS2:

```csv
edge_id,source,target,speed,length,lanes,bottleneck_flow
1,1,3,20.0,10000.0,1.0,0.5
2,1,2,10.0,10000.0,1.0,0.25
3,2,3,10.0,0.0,1.0,
```

