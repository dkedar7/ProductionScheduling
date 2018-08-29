*Local Optimization Strategy (LOS) for site 1
*Site 1 has the following constraints-
*1. It has to meet site 2's demand of 6333 units of P1C by day 216
*2. Site 2's demand of 1964 P2C by day 200
*3. Customers' demand of 9270 units of Px by day 366

*Sends P1C to site 2 on day 215
*Sends P2C to site 2 on day 200

sets
  i 'products' /P1, P2, P3, P1B, P2B, PY, P1C, P2C, PX /
  t 'days' / 1*366 / ;

Positive Variables cost(t);
*This is the variable being optimized (Total Cost)
Variables Tcost;

*Demand for each product by the end of the year
Scalar P1dem /6333/;
Scalar P2dem /486/;
Scalar P3dem /1478/;
Scalar Pxdem /9224/;
scalar Pydem /9161/;

*Site 2's demand for P1C and P2C
scalar P1c1dem /6333/;
scalar P2c1dem /1964/;

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
binary variables Y11(t),Y21(t),Y31(t);
positive variables p1f(t),p2f(t),pxf(t),p1c1(t),p2c1(t),Ip11(t),Ip21(t),Ix1(t),ecost,ocost(t),fixcost(t),tfixcost,invcost(t),tinvcost;
equations eqn,obj;
equations e1,e3,e4,e6,e7,e8,e9,e10,e11, e12, e13, e14, e15, e16, e17,e18,e19,e20,e21;

*Equations for binary variables
eqn(t).. Y11(t)+Y21(t)+Y31(t) =l= 1;

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

*Amount of P1f that is being consumed at site 1 to produce P1C on day t
e1(t).. p1f(t) =e= Y11(t)*(deltat/t1f1);

*Amount of P1C that has been accumulated by the end of day t
e3(t)$(ord(t)>1).. Ip11(t) =e= Ip11(t-1)+p1f(t)-p1c1(t);

*Amount of P2f being consumed at site 1 to produce P2C on day t
e4(t).. p2f(t) =e= Y21(t)*(deltat/t2f1);

*Amount of P2C that has been accumulated by the end of day t
e6(t)$(ord(t)>1).. Ip21(t) =e= Ip21(t-1)+p2f(t)-p2c1(t);

*Amount of PXf being consumed at site 1 to produce PX on day t
e7(t).. pxf(t) =e= Y31(t)*(deltat/txf1);

*Amount of PX being accumulated by the end of day t
e8(t)$(ord(t)>1).. Ix1(t) =e= Ix1(t-1)+pxf(t);

*******
*Cost on day t is equal to the sum of the fixed costs, set up costs, and inventory costs incurred ond that day
e9(t).. cost(t) =e= Cinv('P1C')*Ip11(t)+Y11(t)*Cfix('P1C')+Cinv('P2C')*Ip21(t)+Y21(t)*Cfix('P2C')+Cinv('PX')*Ix1(t)+Y31(t)*Cfix('PX');
*******
*At the end of the year, the total amount of accumulated products must exceed demand
 e10(t)$(ord(t)=card(t)).. Pxdem =l= Ix1(t);
 e11(t)$(ord(t)=216)..   P1c1dem =l= p1c1(t);
 e12(t)$(ord(t)=201)..   P2c1dem =l= p2c1(t);
*******

*Mass balance equations stating that amount used cannot exceed amount accumulated on any day
e13(t)$(ord(t)>1).. p1c1(t) =l= Ip11(t-1);
e14(t)$(ord(t)>1).. p2c1(t) =l= Ip21(t-1);

*Initial conditions for amount of each species that have been accumulated at day 0
e15(t)$(ord(t)=1).. Ix1(t) =e= 0;
e16(t)$(ord(t)=1 and ord(t)>216).. Ip11(t) =e= 0;
e17(t)$(ord(t)=1 and ord(t)>201).. Ip21(t) =e= 0;

e18(t).. fixcost(t) =e= Y11(t)*Cfix('P1C')+ Y21(t)*Cfix('P2C')+ Y31(t)*Cfix('PX');
e19(t).. invcost(t) =e= cost(t) - fixcost(t);
e20.. tfixcost =e= Tcost - sum((t),fixcost(t));
e21.. tinvcost =e= Tcost - tfixcost;

obj.. Tcost =e= sum((t),cost(t));
option MIP = CPLEX;
model schedule /all/;
solve schedule using MIP minimizing Tcost;

execute_unload 'Results_sched_LOS1', Ip11, Ip21, Ix1, invcost;
execute 'gdxxrw.exe Results_sched_LOS1.gdx o=Temp\Results_sched_LOS1.xlsx var=Ip11 rng=Schedule!A1 var=Ip21 rng=Schedule!A4 var=Ix1 rng=Schedule!A7 var=invcost rng=Schedule!A10'
