# ProductionScheduling

Optimal production schedule of a multi-site manufacturing facility.

In this study, we study a model that can be used to optimize an organization’s manufacturing processes through a lot sizing and scheduling problem (LSSP) in a multi-site manufacturing system. The proposed model is applied to a case study involving a multi-site manufacturing system of braking equipment for the automotive industry. A schedule for this process, assuming an integrated approach (global strategy) as well as one assuming a site-by-site approach, is created. This optimization problem includes multi-product demand and cost constraints (fixed and inventory costs). The LSSP is then formulated into a mixed integer problem and the optimization problem is solved in GAMS using a CPLEX (MILP) solver. Through this model, we demonstrate that optimizing a schedule considering a global optimization, encompassing all sites in a manufacturing process, results in a lower total cost than optimizing each site individually on a local level.

![Title image](https://github.com/dkedar7/ProductionScheduling/blob/master/production/plant.PNG?raw=true)
