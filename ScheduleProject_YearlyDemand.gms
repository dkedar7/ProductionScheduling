
sets
  i 'products'          /P1, P2, P3, P1B, P2B, PY, P1C, P2C, PX /
  t 'days' / 1*366 /
  k /1*3/
;



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
binary variables Y11(t), Y12(t), Y13(t), Y21(t), Y22(t), Y23(t), Y31(t), Y32(t), Y33(t);

positive variables p1(t), p2(t),p3(t);

positive variables p1f(t),p2f(t),pxf(t),p1c1(t),p2c1(t),pyf(t),py(t),p1b2(t),p2b2(t),Ip11(t),Ip21(t),Ix1(t),Ip12(t),Ip22(t),Iy2(t),Ip13(t),Ip23(t),Ip33(t),p2bp2(t),p2bp3(t);

equations eqn1, eqn2, eqn3;

equations e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11, e12, e13, e14, e15, e16, e17, e18,e19,e20;

equations e21,e22,e23,e24, e25, e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36,e37,e38,e39,e40,e41,e42,e43,e44,obj;

*Equations for binary variables
eqn1(t).. Y11(t)+Y21(t)+Y31(t) =l= 1;
eqn2(t).. Y12(t)+Y22(t)+Y32(t) =l= 1;
eqn3(t).. Y13(t)+Y23(t)+Y33(t) =l= 1;


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

*Amount of P1C that is being consumed at site 2 to produce P1B on day t
e2(t).. p1c1(t) =e= Y12(t)*(deltat/t1c2);

*Amount of P1C that has been accumulated by the end of day t
e3(t)$(ord(t)>1).. Ip11(t) =e= Ip11(t-1)+p1f(t)-p1c1(t);

*Amount of P2f being consumed at site 1 to produce P2C on day t
e4(t).. p2f(t) =e= Y21(t)*(deltat/t2f1);

*Amount of P2C being consumed at site 2 to produce P2B on day t
e5(t).. p2c1(t) =e= Y22(t)*(deltat/t2c2);

*Amount of P2C that has been accumulated by the end of day t
e6(t)$(ord(t)>1).. Ip21(t) =e= Ip21(t-1)+p2f(t)-p2c1(t);

*Amount of PXf being consumed at site 1 to produce PX on day t
e7(t).. pxf(t) =e= Y31(t)*(deltat/txf1);

*Amount of PX being accumulated by the end of day t
e8(t)$(ord(t)>1).. Ix1(t) =e= Ix1(t-1)+pxf(t);

*******
*Amount of P1B being consumed at site 3 to produce P1 on day t
e9(t).. p1b2(t) =e= Y13(t)*(deltat/t1b3);

*Amount of P1B that has been accumulated by the end of day t
e10(t)$(ord(t)>=1).. Ip12(t) =e= Ip12(t-1)+p1c1(t)-p1b2(t);

*Amount of P2B that has been accumulated by the end of day t
e11(t)$(ord(t)>1).. Ip22(t) =e= Ip22(t-1)+p2c1(t)-p2b2(t);

*Amount of PYf being consumed to produce PY on day t
e12(t).. pyf(t) =e= Y32(t)*(deltat/tyf2);

*Amount of PY that has been accumulated by the end of day t
e13(t)$(ord(t)>1).. Iy2(t) =e= Iy2(t-1)+pyf(t);

*******
*Amount of P1 that has been accumulated by the end of day t
e14(t)$(ord(t)>1).. Ip13(t) =e= Ip13(t-1)+p1b2(t);

*The amount of P2B being consumed at site 3 to produce P2 and P3 on day t
e15(t).. p2b2(t) =e= Y23(t)*(deltat/t2b3)+Y33(t)*(deltat/t33);

*The amount of P2B being consumed at site 3 to produce P2
e41(t).. p2bp2(t) =e= Y23(t)*(deltat/t2b3);

*The amount of P2B being consumed at site 3 to produce P3
e42(t).. p2bp3(t) =e= Y33(t)*(deltat/t33);

*The amount of P2 that has been accumulated by the end of day t
e16(t)$(ord(t)>1).. Ip23(t) =e= Ip23(t-1)+ p2bp2(t);

*The amount of P3 that has been accumulated by the end of day t
e17(t)$(ord(t)>1)..  Ip33(t) =e= Ip33(t-1)+p2bp3(t);

*******

*Cost on day t is equal to the sum of the fixed costs, set up costs, and inventory costs incurred ond that day
e18(t).. cost(t) =e= Cinv('P1')*Ip13(t)+Y13(t)*Cfix('P1')+Cinv('P2')*Ip23(t)+Y23(t)*Cfix('P2')+Cinv('P3')*Ip33(t)+Y33(t)*Cfix('P3')+Cinv('P1B')*Ip12(t)+Y12(t)*Cfix('P1B')
+Cinv('P2B')*Ip22(t)+Y22(t)*Cfix('P2B')+Cinv('PY')*Iy2(t)+Y32(t)*Cfix('PY')+Cinv('P1C')*Ip11(t)+Y11(t)*Cfix('P1C')+Cinv('P2C')*Ip21(t)+Y21(t)*Cfix('P2C')+Cinv('PX')*Ix1(t)+Y31(t)*Cfix('PX');


*******

*At the end of the year, the total amount of accumulated products must exceed demand
 e19(t)$(ord(t)=card(t)).. P1dem =l= Ip13(t);
 e20(t)$(ord(t)=card(t)).. P2dem =l= Ip23(t);
 e21(t)$(ord(t)=card(t)).. P3dem =l= Ip33(t);
 e22(t)$(ord(t)=card(t)).. Pxdem =l= Ix1(t);
 e23(t)$(ord(t)=card(t)).. Pydem =l= Iy2(t);

*******

*Mass balance equations stating that amount used cannot exceed amount accumulated on any day
e24(t)$(ord(t)>1).. p1c1(t) =l= Ip11(t-1);
e25(t)$(ord(t)>1).. p2c1(t) =l= Ip21(t-1);
e26(t)$(ord(t)>1).. p1b2(t) =l= Ip12(t-1);
e27(t)$(ord(t)>1).. p2b2(t) =l= Ip22(t-1);
e28(t)$(ord(t)>1).. p1(t) =l= Ip12(t-1);
e29(t)$(ord(t)>1).. p2(t) =l= Ip22(t-1);
e30(t)$(ord(t)>1).. p3(t) =l= Ip22(t-1);


*The amount of P1, P2, and P3 being produced on day t
e31(t).. p1(t) =e= p1b2(t);
e32(t).. p2(t) =e= p2bp2(t);
e33(t).. p3(t) =e= p2bp3(t);


*Initial conditions for amount of each species that have been accumulated at day 0
e34.. Ip13('1') =e= 0;
e35.. Ip23('1') =e= 0;
e36.. Ip33('1') =e= 0;
e37.. Iy2('1') =e= 0;
e38.. Ix1('1') =e= 0;
e39.. Ip12('1') =e= 0;
e40.. Ip22('1') =e= 0;
e43.. Ip11('1') =e= 0;
e44.. Ip21('1') =e= 0;




obj.. Tcost =e= sum((t),cost(t));
option MIP = CPLEX;
model schedule /all/;
solve schedule using MIP minimizing Tcost;

execute_unload 'Results_sched', Ip13, Ip23, Ip33, Iy2, Ix1, Ip12, Ip22, Ip11, Ip21, cost;
execute 'gdxxrw.exe Results_sched.gdx o=Temp\Results_sched.xlsx var=Ip13 rng=Schedule!A1 var=Ip23 rng=Schedule!A4 var=Ip33 rng=Schedule!A7 var=Iy2 rng=Schedule!A10 var=Ix1 rng=Schedule!A13 var=Ip12 rng=Schedule!A16 var=Ip22 rng=Schedule!A19 var=Ip11 rng=Schedule!A22 var=Ip21 rng=Schedule!A25 var=cost rng=Schedule!A28'






