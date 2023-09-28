
% For an islanded microgrid consisting of two grid-forming converter, a
% grid-following converter, and three constant impedance load


% ========================== Grid-Forming Converter
Pm = 50e3;
Qm = 15e3;

w0 = 2*pi*50;
V0 = 311;

P01 = 50e3;
P02 = 25e3;

mp1 = 0.02*2*pi*50/Pm;
mp2 = 0.04*2*pi*50/Pm;

wp1 = 2*pi*0.1;
wp2 = 2*pi*0.1;

Q01 = 0;
Q02 = 0;

nq1 = 0.025*311/Qm;
nq2 = 0.05*311/Qm;

wq1 = 2*pi*0.1;
wq2 = 2*pi*0.1;




% ========================== Grid-Following Converter
% PLL
kappa_p1 = 0.413076031162106;
kappa_i1 = 7.786299749237402;

% Low-pass Filter for Vgdj
w_gama1 = 2*pi*1;

% Active Power Generation Method 
% Constant Current
Igd1_REF = 30;

% Constant Power
P_GFL1 = 11.5e3;

% Reactive Power Generation Method
% Constant Current
Igq1_REF = 30;

% Constant Power
Q_GFL1 = 1.369341212059503e4;

% Droop
V_L0 = 311;
Q_L01 = 0;
n_gama1 = ( 3.177171824773485e4 ) / ( 0.05*311 );



% ========================== Transmission Network and Load
Ll1 = 3e-3;
r_l1 = 0.8;

Ll2 = 3e-3;
r_l2 = 0.8;

Ls1 = 3e-3;
r_s1 = 0.8;



Lc1 = 2e-3;
r_c1 = 0.5;

Lc2 = 2e-3;
r_c2 = 0.5;



Rb1 = 6;
Lb1 = 3e-3;

Rb2 = 4.2;
Lb2 = 2e-3;

Rb3 = 6;
Lb3 = 3e-3;




