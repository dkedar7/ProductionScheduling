sets
  i 'products'          /P1, P2, P3, P1B, P2B, PY, P1C, P2C, PX /
  t 'days' / 1*366 /
  k /1*3/
  t2 'months' /1*12/
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

equations e21,e22,e23,e24, e25, e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36,e37,e38,e39,e40,e41,e42,e43,e44,e45,obj;

equations e46, e47, e48, e49, e50, e51, e52, e53, e54, e55, e56, e57, e58, e59, e60, e61, e62, e63, e64, e65, e66;

equations e67, e68, e69, e70, e71, e72, e73, e74, e75, e76, e77, e78, e79, e80, e81, e82, e83, e84, e85, e86, e87, e88, e89;

equations e90, e91, e92, e93, e94, e95, e96, e97, e98, e99;

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
e8(t)$(ord(t)>1 and ord(t)<>32 and ord(t)<>60 and ord(t)<>91 and ord(t)<>121 and ord(t)<>152 and ord(t)<>182 and ord(t)<>213 and ord(t)<>244 and ord(t)<>274 and ord(t)<>305 and ord(t)<>335 and ord(t)<>366).. Ix1(t) =e= Ix1(t-1)+pxf(t);
e19(t)$(ord(t)=32).. Ix1(t) =e= Ix1(t-1)+pxf(t)-183;
e20(t)$(ord(t)=60).. Ix1(t) =e= Ix1(t-1)+pxf(t)-1100;
e21(t)$(ord(t)=91).. Ix1(t) =e= Ix1(t-1)+pxf(t)-1205;
e22(t)$(ord(t)=121).. Ix1(t) =e= Ix1(t-1)+pxf(t)-1321;
e23(t)$(ord(t)=152).. Ix1(t) =e= Ix1(t-1)+pxf(t)-636;
e93(t)$(ord(t)=182).. Ix1(t) =e= Ix1(t-1)+pxf(t)-1025;
e94(t)$(ord(t)=213).. Ix1(t) =e= Ix1(t-1)+pxf(t)-1102;
e95(t)$(ord(t)=244).. Ix1(t) =e= Ix1(t-1)+pxf(t)-0;
e96(t)$(ord(t)=274).. Ix1(t) =e= Ix1(t-1)+pxf(t)-1278;
e97(t)$(ord(t)=305).. Ix1(t) =e= Ix1(t-1)+pxf(t)-1374;
e98(t)$(ord(t)=335).. Ix1(t) =e= Ix1(t-1)+pxf(t)-0;
e99(t)$(ord(t)=366).. Ix1(t) =e= Ix1(t-1)+pxf(t)-0;

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
e13(t)$(ord(t)>=1 and ord(t)<>32 and ord(t)<>60 and ord(t)<>91 and ord(t)<>121 and ord(t)<>152 and ord(t)<>182 and ord(t)<>213 and ord(t)<>244 and ord(t)<>274 and ord(t)<>305 and ord(t)<>335 and ord(t)<>366).. Iy2(t) =e= Iy2(t-1)+pyf(t);
e45(t)$(ord(t)=32).. Iy2(t) =e= Iy2(t-1)+pyf(t)-0;
e46(t)$(ord(t)=60).. Iy2(t) =e= Iy2(t-1)+pyf(t)-1520;
e47(t)$(ord(t)=91).. Iy2(t) =e= Iy2(t-1)+pyf(t)-1500;
e48(t)$(ord(t)=121).. Iy2(t) =e= Iy2(t-1)+pyf(t)-896;
e49(t)$(ord(t)=152).. Iy2(t) =e= Iy2(t-1)+pyf(t)-714;
e50(t)$(ord(t)=182).. Iy2(t) =e= Iy2(t-1)+pyf(t)-975;
e51(t)$(ord(t)=213).. Iy2(t) =e= Iy2(t-1)+pyf(t)-1020;
e52(t)$(ord(t)=244).. Iy2(t) =e= Iy2(t-1)+pyf(t)-0;
e53(t)$(ord(t)=274).. Iy2(t) =e= Iy2(t-1)+pyf(t)-1500;
e54(t)$(ord(t)=305).. Iy2(t) =e= Iy2(t-1)+pyf(t)-500;
e55(t)$(ord(t)=335).. Iy2(t) =e= Iy2(t-1)+pyf(t)-0;
e56(t)$(ord(t)=366).. Iy2(t) =e= Iy2(t-1)+pyf(t)-536;
*******
*Amount of P1 that has been accumulated by the end of day t
e14(t)$(ord(t)>=1 and ord(t)<>32 and ord(t)<>60 and ord(t)<>91 and ord(t)<>121 and ord(t)<>152 and ord(t)<>182 and ord(t)<>213 and ord(t)<>244 and ord(t)<>274 and ord(t)<>305 and ord(t)<>335 and ord(t)<>366).. Ip13(t) =e= Ip13(t-1)+p1b2(t);
e57(t)$(ord(t)=32).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-20;
e58(t)$(ord(t)=60).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-921;
e59(t)$(ord(t)=91).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-986;
e60(t)$(ord(t)=121).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-840;
e61(t)$(ord(t)=152).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-956;
e62(t)$(ord(t)=182).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-244;
e63(t)$(ord(t)=213).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-500;
e64(t)$(ord(t)=244).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-150;
e65(t)$(ord(t)=274).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-720;
e66(t)$(ord(t)=305).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-620;
e67(t)$(ord(t)=335).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-256;
e68(t)$(ord(t)=366).. Ip13(t) =e= Ip13(t-1)+p1b2(t)-120;

*The amount of P2B being consumed at site 3 to produce P2 and P3 on day t
e15(t).. p2b2(t) =e= Y23(t)*(deltat/t2b3)+Y33(t)*(deltat/t33);

*The amount of P2B being consumed at site 3 to produce P2
e41(t).. p2bp2(t) =e= Y23(t)*(deltat/t2b3);

*The amount of P2B being consumed at site 3 to produce P3
e42(t).. p2bp3(t) =e= Y33(t)*(deltat/t33);

*The amount of P2 that has been accumulated by the end of day t
e16(t)$(ord(t)>=1 and ord(t)<>32 and ord(t)<>60 and ord(t)<>91 and ord(t)<>121 and ord(t)<>152 and ord(t)<>182 and ord(t)<>213 and ord(t)<>244 and ord(t)<>274 and ord(t)<>305 and ord(t)<>335 and ord(t)<>366).. Ip23(t) =e= Ip23(t-1)+ p2bp2(t);
e69(t)$(ord(t)=32).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-0;
e70(t)$(ord(t)=60).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-20;
e71(t)$(ord(t)=91).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-60;
e72(t)$(ord(t)=121).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-20;
e73(t)$(ord(t)=152).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-60;
e74(t)$(ord(t)=182).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-0;
e75(t)$(ord(t)=213).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-80;
e76(t)$(ord(t)=244).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-60;
e77(t)$(ord(t)=274).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-102;
e78(t)$(ord(t)=305).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-84;
e79(t)$(ord(t)=335).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-0;
e80(t)$(ord(t)=366).. Ip23(t) =e= Ip23(t-1)+p2bp2(t)-0;

*The amount of P3 that has been accumulated by the end of day t
e17(t)$(ord(t)>=1 and ord(t)<>32 and ord(t)<>60 and ord(t)<>91 and ord(t)<>121 and ord(t)<>152 and ord(t)<>182 and ord(t)<>213 and ord(t)<>244 and ord(t)<>274 and ord(t)<>305 and ord(t)<>335 and ord(t)<>366)..  Ip33(t) =e= Ip33(t-1)+p2bp3(t);
e81(t)$(ord(t)=32).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-326;
e82(t)$(ord(t)=60).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-40;
e83(t)$(ord(t)=91).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-140;
e84(t)$(ord(t)=121).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-104;
e85(t)$(ord(t)=152).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-146;
e86(t)$(ord(t)=182).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-62;
e87(t)$(ord(t)=213).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-284;
e88(t)$(ord(t)=244).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-116;
e89(t)$(ord(t)=274).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-84;
e90(t)$(ord(t)=305).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-120;
e91(t)$(ord(t)=335).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-0;
e92(t)$(ord(t)=366).. Ip33(t) =e= Ip33(t-1)+p2bp3(t)-56;
*******

*Cost on day t is equal to the sum of the fixed costs, set up costs, and inventory costs incurred ond that day
e18(t).. cost(t) =e= Cinv('P1')*Ip13(t)+Y13(t)*Cfix('P1')+Cinv('P2')*Ip23(t)+Y23(t)*Cfix('P2')+Cinv('P3')*Ip33(t)+Y33(t)*Cfix('P3')+Cinv('P1B')*Ip12(t)+Y12(t)*Cfix('P1B')
+Cinv('P2B')*Ip22(t)+Y22(t)*Cfix('P2B')+Cinv('PY')*Iy2(t)+Y32(t)*Cfix('PY')+Cinv('P1C')*Ip11(t)+Y11(t)*Cfix('P1C')+Cinv('P2C')*Ip21(t)+Y21(t)*Cfix('P2C')+Cinv('PX')*Ix1(t)+Y31(t)*Cfix('PX');


*******

*At the end of the year, the total amount of accumulated products must exceed demand
* e19(t)$(ord(t)=card(t)).. P1dem =l= Ip13(t);
* e20(t)$(ord(t)=card(t)).. P2dem =l= Ip23(t);
* e21(t)$(ord(t)=card(t)).. P3dem =l= Ip33(t);
* e22(t)$(ord(t)=card(t)).. Pxdem =l= Ix1(t);
* e23(t)$(ord(t)=card(t)).. Pydem =l= Iy2(t);


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

execute_unload 'Results_sched2', Ip13, Ip23, Ip33, Iy2, Ix1, Ip12, Ip22, Ip11, Ip21, cost;
execute 'gdxxrw.exe Results_sched2.gdx o=Temp\Results_sched2.xlsx var=Ip13 rng=Schedule!A1 var=Ip23 rng=Schedule!A4 var=Ip33 rng=Schedule!A7 var=Iy2 rng=Schedule!A10 var=Ix1 rng=Schedule!A13 var=Ip12 rng=Schedule!A16 var=Ip22 rng=Schedule!A19 var=Ip11 rng=Schedule!A22 var=Ip21 rng=Schedule!A25 var=cost rng=Schedule!A28'






