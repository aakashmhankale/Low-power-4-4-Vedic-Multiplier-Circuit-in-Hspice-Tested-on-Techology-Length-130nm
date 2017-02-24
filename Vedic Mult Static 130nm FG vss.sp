**** Vedic Multiplier Course grain Vss*********

.include '130nm_bsim4.txt' 
 .tran 1p 60ns 
 .options post 
 .temp 100 
 .global Vdd 
 .global Vss 
 .param techlength=130n 
 .param wnmos=2*techlength 
 .param wpmos=2.3*wnmos 
 .param maxswing = 1.3v
 .param wnmosFG=4*techlength
  vSupply Vdd 0 maxswing 
  vGround Vss 0 0V 

*16****2 input Xor gate***************

.subckt ORex in1 in2 xorout1

M1 N1 in1 vdd vdd PMOS W=wpmos L=techlength 
M2 N1 in1 n22 n22 NMOS W=wnmos L=techlength 
M22 N22 in20 vss vss NMOS W=wnmos L=techlength
M3 xorout1 in2 in1 vdd PMOS W=wpmos L=techlength 
M4 xorout1 in2 N1 N22 NMOS W=wnmos L=techlength 

.ends

*27**********2 input AND gate**************

.subckt AND in3 in4 andout1

M5 N2 in3 vdd vdd pmos W=wpmos L=techlength 
M6 N2 in4 vdd vdd pmos W=wnmos L=techlength 
M7 N2 in3 N3  vss nmos W=wpmos L=techlength 
M8 N3 in4 vss vss nmos W=wnmos L=techlength

M9 andout1 N2 vdd vdd PMOS W=wpmos L=techlength 
M10 andout1 N2 vss vss NMOS W=wnmos L=techlength 

.ends

*41**********2 input OR gate****************

.subckt OR11 in10 in11 outor

M11 N4 in10 vdd vdd pmos W=wpmos L=techlength 
M12 N5 in11 N4  vdd pmos W=wpmos L=techlength 
M13 N5 in10 N40 N40 nmos W=wnmos L=techlength

M40 N40 in20 vss vss nmos W=wnmosFG L=techlength

M14 N5 in11 N41 N41 nmos W=wnmos L=techlength

M41 N41 in20 vss vss nmos W=wnmosFG L=techlength

M15 outor N5 vdd vdd pmos W=wpmos L=techlength 
M16 outor N5 N42 N42 nmos W=wnmos L=techlength

M42 N42 in20 vss vss nmos W=wnmosFG L=techlength

.ends

*55**********3 input X-or gate using 2 input ex-or gate****

.subckt exor31 in12 in13 in14 xorout31

XORex4 in12 in13 x5       ORex
XORex5 x5   in14 xorout31 ORex
.ends

*65***********Half adder****************
.subckt halfadder in5 in6 sum1 carry1
**Sum***
Xorx1 in5 in6 sum1 ORex
**Carry**
Xand1 in5 in6 Carry1 AND

.ends

*74*******************************

.subckt vedicmult a1 ao b1 bo W W1 W2 W3


Xand2 ao bo W AND
Xand3 a1 bo P AND
Xand4 ao b1 Q AND
Xand5 a1 b1 R AND


Xhalfadder1 P Q W1 C1 halfadder
Xhalfadder2 C1  R W2 W3 halfadder

.ends

*96***** Full adder ******************

.subckt fulladder in7 in8 in9 sum2 carry2

XOrex2 in7 in8 x3     ORex
XORex3 x3  in9 sum2   ORex
Xand6  in7 in8 x4     AND
Xand7  x3  in9 x5     AND
Xor1   x4  x5  carry2 OR11

.ends

*108****** 4 bit ripple carry adder*******

.subckt rippleCA n3 n2 n1 n0 m3 m2 m1 m0 d3 d2 d1 d0 Ca0

XORex6        n0 m0 d0         ORex
Xand8         n0 m0 x6         AND
Xexor311      n1 m1 x6 d1      exor31
Xfulleadder3  n1 m1 x6 x10 x7  fulladder
Xexor312      n2 m2 x7 d2      exor31
Xfulladder4   n2 m2 x7 x11 x8  fulladder
Xexor313      n3 m3 x8 d3      exor31
Xfulladder    n3 m3 x8 x12 Ca0 fulladder

.ends


*124**********4*4 bit vedic multiplier ***********************

.subckt VM44 L3 L2 L1 L0 K3 K2 K1 K0 Q7 Q6 Q5 Q4 Q3 Q2 Q1 Q0 ch3

Xvedicmult1 L1 L0 K1 K0 Q0  Q1  h1  h2   vedicmult
Xvedicmult2 L1 L0 K3 K2 h3  h4  h5  h6   vedicmult
Xvedicmult3 L3 L2 K1 K0 h7  h8  h9  h10  vedicmult
Xvedicmult4 L3 L2 K3 K2 h11 h12 h13 h14  vedicmult

Xrippleca2 h6 h5 h4 h3 h10 h9 h8 h7 h18 h17 h16 h15 ch1 rippleCA
Xrippleca3 h18 h17 h16 h15 0  0  h2 h1  h20 h19 Q3 Q2 ch2 rippleCA

Xrippleca4 h14 h13 h12 h11 ch1 0 h20 h19 Q7 Q6 Q5 Q4 ch3 rippleCA

.ends

XVM441 A3 A2 A1 A0 B3 B2 B1 B0 S7 S6 S5 S4 S3 S2 S1 S0 Carry VM44

***********Static Calculation******
 *Inputs A3A2A1A0 = '0000' B3B2B1B0="1111"case 

  VA0 A0 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VA1 A1 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VA2 A2 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VA3 A3 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VB0 B0 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB1 B1 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB2 B2 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VB3 B3 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 

  .measure tran leakage0 rms I(vSupply) FROM=10n TO=15n 
  .print leakage0
  .alter 
  .tran 1p 60ns 

 *Inputs A3A2A1A0 = '0011' B3B2B1B0="1111"case 

  VA0 A0 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VA1 A1 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VA2 A2 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VA3 A3 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VB0 B0 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB1 B1 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB2 B2 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VB3 B3 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 

  .measure tran leakage1 rms I(vSupply) FROM=10n TO=15n 
  .print leakage1
  .alter 
  .tran 1p 60ns 

 *Inputs A3A2A1A0 = '1100' B3B2B1B0="1111"case 

  VA0 A0 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VA1 A1 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VA2 A2 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VA3 A3 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VB0 B0 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB1 B1 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB2 B2 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VB3 B3 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 

  .measure tran leakage2 rms I(vSupply) FROM=10n TO=15n 
  .print leakage2
  .alter 
  .tran 1p 60ns 

 *Inputs A3A2A1A0 = '1010' B3B2B1B0="1111"case 

  VA0 A0 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VA1 A1 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VA2 A2 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VA3 A3 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VB0 B0 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB1 B1 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB2 B2 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VB3 B3 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 

  .measure tran leakage3 rms I(vSupply) FROM=10n TO=15n 
  .print leakage3
  .alter 
  .tran 1p 60ns

 *Inputs A3A2A1A0 = '0110' B3B2B1B0="1001"case 

  VA0 A0 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VA1 A1 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 
  VA2 A2 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VA3 A3 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VB0 B0 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB1 B1 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)  
  VB2 B2 Vss pulse (0 0 0.49ns 0.01ns 0.01ns 0.49ns 1ns)
  VB3 B3 Vss pulse (maxswing maxswing 0.49ns 0.01ns 0.01ns 0.49ns 1ns) 

  .measure tran leakage4 rms I(vSupply) FROM=10n TO=15n
  .print leakage4
  .alter 
  .tran 1p 60ns
.end