*Local Optimization Strategy (LOS) for site 2
*Site 1 has the following constraints-
*1. It has to meet site 3's demand of 6333 units of P1B by day 264
*2. Site 3's demand of 1964 P2B by day 257
*3. Customers' demand of 9190 units of Py by day 366

*Gets P1C from site 1 on day  215
*Gets P2C from site 2 on day 200

*Sends P1B to site 3 on day 263
*Sends P2B to site 3 on day 257

sets
  i 'products' /P1, P2, P3, P1B, P2B, PY, P1C, P2C, PX /
  t 'days' / 1*366 /;

*Where Pxdem is demand for x species
Positive Variables cost(t);

*This is the variable being optimized (Total Cost)
Variables Tcost;

*Demand for each product by the end of the year
Scalar P1dem /6333/;
Scalar P2dem /486/;
Scalar P3dem /1478/;
Scalar Pxdem /9224/;
scalar Pydem /9161/;
scalar P1b2dem /6333/;
scalar P2b2dem /1964/;

*Inventory Cost per day
Parameter Cinv(i) 'inventory cost for each unit'/
 P1 0.011583
 P2 0.0115
 P3 0.02792
 P1B 0.03875
 P2B 0.03825
 PY 0.0419
 P1C 0.10625
 P2C 0.1265
 PX 0.1076/;

*Fixed Cost per day assuming plant is running
Parameter Cfix(i) 'fixed cost for each reaction'/
 P1 599
 P2 599
 P3 599
 P1B 569
 P2B 569
 PY 569
 P1C 462
 P2C 462
 PX 462
/;

*Binary Variables for Site 2. First index is input, second index is the site, third index is the day
binary variables Y12(t), Y22(t), Y32(t);
positive variables p1c1(t),p2c1(t),pyf(t),Ip12(t),Ip22(t),Iy2(t),p1b2(t),p2b2(t),ecost,ocost(t),Ip1c1(t),Ip2c1(t),fixcost(t),tfixcost,invcost(t),tinvcost;
equations e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19,e20,e21,far,e22,e23,e24,e25;
equations eqn,obj;

*Equations for binary variables
eqn(t).. Y12(t)+Y22(t)+Y32(t) =l= 1;

*Processing time for each species in days/unit
scalar t1f1 /0.0021875/;
scalar t1c2 /0.0025/;
scalar t2f1 /0.0021875/;
scalar t2c2 /0.0025/;
scalar txf1 /0.002263/;
scalar t1b3 /0.00417/;
scalar tyf2 /0.0025/;
scalar t33 /0.005/;
scalar t2b3 /0.0046/;


*Fraction of the day during which production can occur
scalar deltat /0.333/;
* Amount of P1B made at site 2 on day t
e1(t).. p1c1(t) =e= Y12(t)*(deltat/t1c2);

*Amount of P2B made at site 2 on day t
e2(t).. p2c1(t) =e= Y22(t)*(deltat/t2c2);

*Amount of P1B that has been accumulated by the end of day t
e3(t)$(ord(t)>=1).. Ip12(t) =e= Ip12(t-1)+p1c1(t)-p1b2(t);

*Amount of P2B that has been accumulated by the end of day t
e4(t)$(ord(t)>1).. Ip22(t) =e= Ip22(t-1)+p2c1(t)-p2b2(t);

*Amount of Pyf being consumed to produce PY on day t
e5(t).. pyf(t) =e= Y32(t)*(deltat/tyf2);

*Amount of PY that has been accumulated by the end of day t
e6(t)$(ord(t)>1).. Iy2(t) =e= Iy2(t-1)+pyf(t);

*Cost on day t is equal to the sum of the fixed costs, set up costs, and inventory costs incurred ond that day
e7(t).. cost(t) =e= Cinv('P1B')*Ip12(t)+Y12(t)*Cfix('P1B')+Cinv('P2B')*Ip22(t)+Y22(t)*Cfix('P2B')+Cinv('PY')*Iy2(t)+Y32(t)*Cfix('PY');

*Cost on day t taking into account the inventory cost of raw materials stored. This does not appear in the objective function
e8(t).. ocost(t) =e= cost(t) + Cinv('P1C')*Ip1c1(t) + Cinv('P2C')*Ip2c1(t);

*Total cost
e9.. ecost =e= sum((t),ocost(t));

*Demand constraints
e10(t)$(ord(t)=264).. P1b2dem =l= p1b2(t);
e11(t)$(ord(t)=257).. P2b2dem =l= p2b2(t);
e12(t)$(ord(t)=366).. Pydem =l= Iy2(t);

*Mass balance equations stating that amount used cannot exceed amount accumulated on any day
e13(t)$(ord(t)>1).. p1b2(t) =l= Ip12(t-1);
e14(t)$(ord(t)>1).. p2b2(t) =l= Ip22(t-1);

*Initial and final conditions for amount of each species that have been accumulated at day 0 and after they are sent away
e15.. Iy2('1') =e= 0;
far.. Ip22('1') =e= 0;
e16(t)$(ord(t)<215 and ord(t)>263).. Ip12(t) =e= 0;
e17(t)$(ord(t)>256).. Ip22(t) =e= 0;
e18(t)$(ord(t)<215 and ord(t)>263).. Ip1c1(t) =e= 0;
e19(t)$(ord(t)<200 and ord(t)>256).. Ip2c1(t) =e= 0;

*Material balance. Amount of products made should never exceed the initial amont of raw materials.
e20(t)$(ord(t)>215 and ord(t)<263).. Ip1c1('215') =e= Ip1c1(t) + Ip12(t);
e21(t)$(ord(t)>200 and ord(t)<256).. Ip2c1('200') =e= Ip2c1(t) + Ip22(t);

*Objective function. Cost of manufacturing
obj.. Tcost =e= sum((t),cost(t));

e22(t).. fixcost(t) =e=  Y12(t)*Cfix('P1B')+ Y22(t)*Cfix('P2B')+ Y32(t)*Cfix('PY');
e23(t).. invcost(t) =e= ocost(t) - fixcost(t);
e24.. tfixcost =e= ecost - sum((t),fixcost(t));
e25.. tinvcost =e= ecost - tfixcost;

option MIP = CPLEX;
model schedule /all/;
solve schedule using MIP minimizing Tcost;

execute_unload 'Results_sched_LOS2', Iy2, Ip12, Ip22, invcost;
execute 'gdxxrw.exe Results_sched_LOS2.gdx o=Temp\Results_sched_LOS2.xlsx var=Ip12 rng=Schedule!A1 var=Ip22 rng=Schedule!A4 var=Iy2 rng=Schedule!A7 var=invcost rng=Schedule!A10'






