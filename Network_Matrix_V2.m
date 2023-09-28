

B_l1 = [r_l1 -w0*Ll1; w0*Ll1 r_l1];
B_l2 = [r_l2 -w0*Ll2; w0*Ll2 r_l2];
B_s1 = [r_s1 -w0*Ls1; w0*Ls1 r_s1];

D_b1 = ( 1/( Rb1^2 + (w0*Lb1)^2 ) ) * [Rb1 w0*Lb1; -w0*Lb1 Rb1];
D_b2 = ( 1/( Rb2^2 + (w0*Lb2)^2 ) ) * [Rb2 w0*Lb2; -w0*Lb2 Rb2];
D_b3 = ( 1/( Rb3^2 + (w0*Lb3)^2 ) ) * [Rb3 w0*Lb3; -w0*Lb3 Rb3];

D_c1 = ( 1/( r_c1^2 + (w0*Lc1)^2 ) ) * [r_c1 w0*Lc1; -w0*Lc1 r_c1];
D_c2 = ( 1/( r_c2^2 + (w0*Lc2)^2 ) ) * [r_c2 w0*Lc2; -w0*Lc2 r_c2];

B_LS = [B_l1 zeros(2) zeros(2); zeros(2) B_l2 zeros(2); zeros(2) zeros(2) B_s1];
D_N = [D_b1+D_c1 -D_c1 zeros(2); -D_c1 D_b2+D_c1+D_c2 -D_c2; zeros(2) -D_c2 D_b3+D_c2];

M_Ynl = ( eye(6) + D_N * B_LS ) \ D_N;

Ma_Ynl = M_Ynl(1:4,1:6);
Mb_Ynl = M_Ynl(5:6,1:4);
Mc_Ynl = M_Ynl(5:6,5:6);
iMc_Ynl = inv(Mc_Ynl);

