*Local Optimization Strategy (LOS) for site 2
*Site 1 has the following constraints-
*1. It has to meet customers' demand of 6333 units of P1 by day 366
*2. Customers' demand of 486 units P2 by day 366
*3. Customers' demand of 1478 units of Py by day 366

*Gets P1B from 2 on day 263
*Gets P2B from 2 on day 257

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
 PX 0.1076
/;

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

*Binary Variables for Site 1. First index is input, second index is the site, third index is the day
binary variables Y13(t), Y23(t), Y33(t);
positive variables p1(t), p2(t),p3(t),p1b2(t),p2b2(t),Ip13(t),Ip23(t),Ip33(t),p2bp2(t),p2bp3(t),Ip1b(t),Ip2b(t),ocost(t),ecost,fixcost(t),tfixcost,invcost(t),tinvcost;
equations eqn,obj;
equations e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30;

*Equations for binary variables
eqn(t).. Y13(t)+Y23(t)+Y33(t) =l= 1;

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

*******
*Amount of P1B being consumed at site 3 to produce P1 on day t
e1(t).. p1b2(t) =e= Y13(t)*(deltat/t1b3);

*******
*Amount of P1 that has been accumulated by the end of day t
e2(t)$(ord(t)>1).. Ip13(t) =e= Ip13(t-1)+p1b2(t);

*The amount of P2B being consumed at site 3 to produce P2 and P3 on day t
e3(t).. p2b2(t) =e= Y23(t)*(deltat/t2b3)+Y33(t)*(deltat/t33);

*The amount of P2B being consumed at site 3 to produce P2
e4(t).. p2bp2(t) =e= Y23(t)*(deltat/t2b3);

*The amount of P2B being consumed at site 3 to produce P3
e5(t).. p2bp3(t) =e= Y33(t)*(deltat/t33);

*The amount of P2 that has been accumulated by the end of day t
e6(t)$(ord(t)>1).. Ip23(t) =e= Ip23(t-1)+ p2bp2(t);

*The amount of P3 that has been accumulated by the end of day t
e7(t)$(ord(t)>1)..  Ip33(t) =e= Ip33(t-1)+p2bp3(t);

*******
*Cost on day t is equal to the sum of the fixed costs, set up costs, and inventory costs incurred ond that day
e8(t).. cost(t) =e= Cinv('P1')*Ip13(t)+Y13(t)*Cfix('P1')+Cinv('P2')*Ip23(t)+Y23(t)*Cfix('P2')+Cinv('P3')*Ip33(t)+Y33(t)*Cfix('P3');
e9(t).. ocost(t) =e= cost(t)+Cinv('P1B')*Ip1b(t)+Cinv('P2B')*Ip2b(t);
e10.. ecost =e= sum((t),ocost(t));

*******
*At the end of the year, the total amount of accumulated products must exceed demand
e11(t)$(ord(t)=card(t)).. P1dem =l= Ip13(t);
e12(t)$(ord(t)=card(t)).. P2dem =l= Ip23(t);
e13(t)$(ord(t)=card(t)).. P3dem =l= Ip33(t);
*******

*The amount of P1, P2, and P3 being produced on day t
e14(t).. p1(t) =e= p1b2(t);
e15(t).. p2(t) =e= p2bp2(t);
e16(t).. p3(t) =e= p2bp3(t);

*Initial and final conditions for amount of each species that have been accumulated at day 0 and after they are sent away
e17.. Ip13('1') =e= 0;
e18.. Ip23('1') =e= 0;
e19.. Ip33('1') =e= 0;
e20.. Ip1b('1') =e= 0;
e21.. Ip2b('1') =e= 0;
e22(t)$(ord(t)<263).. Ip13(t) =e= 0;
e23(t)$(ord(t)<257).. Ip23(t) =e= 0;
e24(t)$(ord(t)<344).. Ip33(t) =e= 0;

*Material balance. Amount of products made should never exceed the initial amont of raw materials.
e25(t)$(ord(t)>263).. Ip1b('263') =e= Ip1b(t) + Ip13(t);
e26(t)$(ord(t)>257).. Ip2b('257') =e= Ip2b(t) + Ip23(t) + Ip33(t);

e27(t).. fixcost(t) =e= Y13(t)*Cfix('P1')+Y23(t)*Cfix('P2')+Y33(t)*Cfix('P3');
e28(t).. invcost(t) =e= ocost(t) - fixcost(t);
e29.. tfixcost =e= ecost - sum((t),fixcost(t));
e30.. tinvcost =e= ecost - tfixcost;

obj.. Tcost =e= sum((t),cost(t));
option MIP = CPLEX;
model schedule /all/;
solve schedule using MIP minimizing Tcost;

execute_unload 'Results_sched', Ip13, Ip23, Ip33,invcost
execute 'gdxxrw.exe Results_sched.gdx o=Temp\Results_sched_LOS3.xlsx var=Ip13 rng=Schedule!A1 var=Ip23 rng=Schedule!A4 var=Ip33 rng=Schedule!A7 var=invcost rng=Schedule!A10'






