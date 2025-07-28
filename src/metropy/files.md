# Files

**Table of Contents**

<!-- toc -->

```
output/
├── graphs
│   └── road_network.osm
│       ├── lanes_distribution_length_weights.pdf
│       ├── lanes_distribution.pdf
│       ├── length_distribution.pdf
│       ├── road_type_pie_length_weights.pdf
│       ├── road_type_pie.pdf
│       ├── speed_limit_distribution_length_weights.pdf
│       └── speed_limit_distribution.pdf
├── maps
│   ├── chambery_aav.jpg
│   └── france_aav.jpg
├── osm-road-import
│   ├── edges_raw.parquet
│   ├── osm_output.txt
│   └── urban_areas.parquet
└── simulation_area.parquet
```

## Files outside of directories

### Simulation area

- **Filename:** `simulation_area.parquet`
- **Geospatial:** Yes
- **Columns:**
  - `geometry`: Polygon of the simulation area
- **Comment:** The file contains only a single feature, representing the simulation area.

## Directory `osm-road-import`

### Raw edges

- **Filename:** `edges_raw.parquet`
- **Geospatial:** Yes
- **Columns:**
  - `geometry`: LineString of the edge
  - `edge_id` (UInt64): Identifier of the edge
  - `osm_id` (UInt64): Identifier of the corresponding OpenStreetMap way
  - `source` (UInt64): Identifier of the OpenStreetMap node of the edge's first node
  - `target` (UInt64): Identifier of the OpenStreetMap node of the edge's last node
  - `road_type` (String): Value of the `highway` tag
  - `name` (String): Value of the `name` tag (or `addr:street`, or `ref` as fallbacks)
  - `toll` (Boolean): Whether the way has tag `toll=yes`
  - `roundabout` (Boolean): Whether the way has tag `junction=roundabout`
  - `oneway` (Boolean): Whether the way has tag `oneway=yes`
  - `speedlimit` (Float64): Speed limit on the edge, in km/h (if available)
  - `lanes` (Float64): Number of lanes on the edge (if available)
  - `give_way` (Boolean): Whether the edge ends with a give-way sign
  - `stop` (Boolean): Whether the edge ends with a stop sign
  - `traffic_signals` (Boolean): Whether the edge ends with traffic signals
  - `length` (Float64): Length of the edge's geometry, in the same unit as the CRS
  - `urban` (Boolean): Whether the edge is within urban areas

### Urban areas

- **Filename:** `urban_areas.parquet`
- **Geospatial:** Yes
- **Columns:**
  - `geometry`: LineString of the edge
  - `osm_id` (UInt64): Identifier of the corresponding OpenStreetMap way (even numbers) or relation (odd
    numbers), see [https://docs.osmcode.org/pyosmium/latest/user_manual/03-Working-with-Geometries/#the-pyosmium-area-type](https://docs.osmcode.org/pyosmium/latest/user_manual/03-Working-with-Geometries/#the-pyosmium-area-type)
  - `landuse` (String): Value of the `landuse` tag
