
Important!!!
These codes are excuted in MATLAB R2021b!!!



Contents:

1) Input_Parameters_V6_2

The default parameters of the microgrid: Tables I, II and III

2) Network_Matrix_V2

Related matrixes: Equations (10), (11) and (12)

3) Derive_SEP_V3_1

Derive the values of state variables of the stable equilibrium point (SEP), using the Newton's Method

4) Derive_UEP_V4_1

Derive the values of state variables of the unstable equilibrium point (UEP), using the Newton's Method

5) Derive_Trajectory_V6_2

Using Runge-Kutta numerical method to derive the trajectory

6) BoA_cAcP_cReP_pGFL_V2_1

Derive the basins of attraction in ( delta_{L1}, y_{omega1} )-plane

The values of Sd1 and Sq1 can be selected by the users

7) BoA_cAcP_cReP_pGFM_V2_2

Derive the basins of attraction in ( delta_{M2}, y_2 )-plane

The values of Sd1 and Sq1 can be selected by the users




How to use these algorithms:

1) Derive the basins of attraction:

First step: open "BoA_cAcP_cReP_pGFL_V2_1" or "BoA_cAcP_cReP_pGFM_V2_2"

Second step: selecting Sd1 and Sq1

Third step: run the program

Note!!!

In "BoA_cAcP_cReP_pGFL_V2_1", the resolution of the derived figure depends on "Array_Delta_L1" and "Array_Y_Omega1".

High resolution may require large computation cost. 

Therefore, the length of "Array_Delta_L1" and "Array_Y_Omega1" can be reduced to speed up the derivation and get a rough figure.

For "BoA_cAcP_cReP_pGFM_V2_2", the resolution of the derived figure depends on "Array_Delta_M2" and "Array_y2". The length of them can be adjusted by the users.


2) Derive the SEP:

Related programs: "Input_Parameters_V6_2", "Network_Matrix_V2", and "Derive_SEP_V3_1"


3) Derive the trajectory:

Related programs: "Input_Parameters_V6_2", "Network_Matrix_V2", "Derive_SEP_V3_1", and "Derive_Trajectory_V6_2"





















