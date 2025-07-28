# Glossary

- **Agent**: Autonomous entity choosing and performing one (and only one) **travel alternative** for
  each simulated day.
- **Alternative**: See **travel alternative**.
- **Car**: Denote a commonly used **vehicle type**, or a specific **vehicle** instance of this
  vehicle type.
- **Destination**: Ending **node** of a **trip**.
- **Edge**: Segment of the **road-network** graph representing a **road**.
- **Intersection**: Point where multiple **roads** cross / intersect. Represented by a **node** on
  the **road-network** graph.
- **Link**: See **road** or **edge**.
- **Mode**: Mean / manner of performing a **trip** (e.g., **car**, public transit, walking).
- **Node**: Point at the intersection of multiple **edges** on the **road-network** graph.
- **Origin**: Starting **node** of a **trip**.
- **Road**: Segment of the **road network** that is used by vehicles to move around.
- **Road network**: Infrastructures that can be used by **vehicles** to perform **road trips**. It
  is defined as a graph of **nodes** and **edges**.
- **Road trip**: **Trip** to go from an **origin** to a **destination** using a **vehicle**
  traveling on the **road network**.
- **Route**: Sequence of **edges**, or equivalently **roads**, representing the **trip** made by a
  **vehicle** on the **road network** to connect an **origin** to a **destination**.
- **Travel alternative**: Sequence of **trips** to be performed by an **agent**. The sequence can be
  empty if the **agent** is not traveling.
- **Trip**: Act of traveling from one place to another. See **road trip** and **virtual trip**.
- **Vehicle**: Object, such as a car, that can move / travel on a **road network**.
- **Vehicle type**: Definition of the characteristics shared by multiple **vehicles**.
- **Virtual trip**: **Trip** with an exogenous travel time (i.e., a travel time independent from the
  choices of the other agents).
