
% Step
h = 1e-3;

% Length
Num = floor( Tal_Time / h );

% Array
P1 = zeros(Num,1);
Q1 = zeros(Num,1);
P2 = zeros(Num,1);
Q2 = zeros(Num,1);
Delta_M2 = zeros(Num,1);
VLm1 = zeros(Num,1); 
Yomega1 = zeros(Num,1);
Delta_L1 = zeros(Num,1);

Delta_M1 = zeros(Num,1);
w_M1 = zeros(Num,1); w_M2 = zeros(Num,1);
DW1_PLL = zeros(Num,1); w_L1 = zeros(Num,1); 
Vfd1 = zeros(Num,1); Vfq1 = zeros(Num,1); VfD1 = zeros(Num,1); VfQ1 = zeros(Num,1);
Vfd2 = zeros(Num,1); Vfq2 = zeros(Num,1); VfD2 = zeros(Num,1); VfQ2 = zeros(Num,1);
Ild1 = zeros(Num,1); Ilq1 = zeros(Num,1); IlD1 = zeros(Num,1); IlQ1 = zeros(Num,1);
Ild2 = zeros(Num,1); Ilq2 = zeros(Num,1); IlD2 = zeros(Num,1); IlQ2 = zeros(Num,1);
Vgd1 = zeros(Num,1); Vgq1 = zeros(Num,1); VgD1 = zeros(Num,1); VgQ1 = zeros(Num,1);
Igd1 = zeros(Num,1); Igq1 = zeros(Num,1); IgD1 = zeros(Num,1); IgQ1 = zeros(Num,1);
p1 = zeros(Num,1); q1 = zeros(Num,1); p2 = zeros(Num,1); q2 = zeros(Num,1); 

Time = zeros(Num,1);
Delta_M1_SR = zeros(Num,1); Delta_M2_SR = zeros(Num,1);
Delta_L1_SR = zeros(Num,1);


% Temporary Variables
P1_Temp = 0; Q1_Temp = 0;
P2_Temp = 0; Q2_Temp = 0;
Delta_M2_Temp = 0;
VLm1_Temp = 0;
Yomega1_Temp = 0; 
Delta_L1_Temp = 0; 

Delta_M1_Temp = 0;
w_M1_Temp = 0; w_M2_Temp = 0;
DW1_PLL_Temp = 0;
w_L1_Temp = 0; 
Vfd1_Temp = 0; Vfq1_Temp = 0; VfD1_Temp = 0; VfQ1_Temp = 0;
Vfd2_Temp = 0; Vfq2_Temp = 0; VfD2_Temp = 0; VfQ2_Temp = 0;
Ild1_Temp = 0; Ilq1_Temp = 0; IlD1_Temp = 0; IlQ1_Temp = 0;
Ild2_Temp = 0; Ilq2_Temp = 0; IlD2_Temp = 0; IlQ2_Temp = 0;
Vgd1_Temp = 0; Vgq1_Temp = 0; VgD1_Temp = 0; VgQ1_Temp = 0;
Igd1_Temp = 0; Igq1_Temp = 0; IgD1_Temp = 0; IgQ1_Temp = 0;
p1_Temp = 0; q1_Temp = 0; p2_Temp = 0; q2_Temp = 0; 

DP1_Temp1 = 0; DP1_Temp2 = 0; DP1_Temp3 = 0; DP1_Temp4 = 0;
DQ1_Temp1 = 0; DQ1_Temp2 = 0; DQ1_Temp3 = 0; DQ1_Temp4 = 0;
DP2_Temp1 = 0; DP2_Temp2 = 0; DP2_Temp3 = 0; DP2_Temp4 = 0;
DQ2_Temp1 = 0; DQ2_Temp2 = 0; DQ2_Temp3 = 0; DQ2_Temp4 = 0;
D_Delta_M2_Temp1 = 0; D_Delta_M2_Temp2 = 0; D_Delta_M2_Temp3 = 0; D_Delta_M2_Temp4 = 0;
DVLm1_Temp1 = 0; DVLm1_Temp2 = 0; DVLm1_Temp3 = 0; DVLm1_Temp4 = 0;
DYomega1_Temp1 = 0; DYomega1_Temp2 = 0; DYomega1_Temp3 = 0; DYomega1_Temp4 = 0;
D_Delta_L1_Temp1 = 0; D_Delta_L1_Temp2 = 0; D_Delta_L1_Temp3 = 0; D_Delta_L1_Temp4 = 0;


Sign_DW1_Sat = 0;               % 0: Saturation is disable; 1: Saturation is enable, and the Limit is adjusted
Sign_DW1_Sat_Last = 0;

Sat_DW_PLL_Int = 2*pi*50;       % Initial Saturation Limit
Sat_DW_PLL_Fnl = 2*pi*2;        % If the Saturation is enabled, the limit is adjusted

Num_DW_SatChg = floor( (20e-3) / h );
Cnt_DW_SatChg = 0;

if( Enable_PLL_Limit == 1 )
    % Fixed limit
    Sat_DW_PLL = Sat_DW_PLL_Fixed;
else
    Sat_DW_PLL = Sat_DW_PLL_Int;
end


% Recognize the oscillating angle
Recog_Start_Time = 5;
Recog_Start_Num = floor( Recog_Start_Time / h );

Eff_Pass_Num = 2;
Pass_Cnt = zeros(2,1);
Eff_Pass_Sign = zeros(2,1);



% Initialization for some state variables
P1(1) = Initial.P1;
Q1(1) = Initial.Q1;
P2(1) = Initial.P2;
Q2(1) = Initial.Q2;
Delta_M2(1) = Initial.Delta_M2;
VLm1(1) = Initial.VLm1; 
Yomega1(1) = Initial.Yomega1;
Delta_L1(1) = Initial.Delta_L1;

% Runge-Kutta numerical algorithms
for i = 2 : Num
    % Step 1
    % State Variables
    P1_Temp = P1(i-1);
    Q1_Temp = Q1(i-1);
    P2_Temp = P2(i-1);
    Q2_Temp = Q2(i-1);
    Delta_M2_Temp = Delta_M2(i-1);
    VLm1_Temp = VLm1(i-1);
    Yomega1_Temp = Yomega1(i-1);
    Delta_L1_Temp = Delta_L1(i-1);
    
    % Other variables
    w_M1_Temp = w0 + mp1 * P1_Temp;
    Vfd1_Temp = V0 + nq1 * Q1_Temp;
    Vfq1_Temp = 0;
    w_M2_Temp = w0 + mp2 * P2_Temp;
    Vfd2_Temp = V0 + nq2 * Q2_Temp;
    Vfq2_Temp = 0;

    VfD1_Temp = Vfd1_Temp * cos(Delta_M1_Temp) - Vfq1_Temp * sin(Delta_M1_Temp);
    VfQ1_Temp = Vfd1_Temp * sin(Delta_M1_Temp) + Vfq1_Temp * cos(Delta_M1_Temp);
    VfD2_Temp = Vfd2_Temp * cos(Delta_M2_Temp) - Vfq2_Temp * sin(Delta_M2_Temp);
    VfQ2_Temp = Vfd2_Temp * sin(Delta_M2_Temp) + Vfq2_Temp * cos(Delta_M2_Temp);

    VfDQ1_Vector = [VfD1_Temp; VfQ1_Temp];
    VfDQ2_Vector = [VfD2_Temp; VfQ2_Temp];

    if( Sd1 == 1 )
        Igd1_Temp = Igd1_REF;
    else
        Igd1_Temp = P_GFL1 / ( 1.5 * VLm1_Temp );
    end

    if( Sq1 == 1 )
        Igq1_Temp = 0;
    elseif( Sq1 == 2 )
        Igq1_Temp = -Igq1_REF;
    elseif( Sq1 == 3 )
        Igq1_Temp = -Q_GFL1 / ( 1.5 * VLm1_Temp );
    else
        Igq1_Temp = -( Q_L01 + n_gama1 * ( V_L0 - VLm1_Temp ) ) / ( 1.5 * VLm1_Temp );
    end

    IgD1_Temp = Igd1_Temp * cos(Delta_L1_Temp) - Igq1_Temp * sin(Delta_L1_Temp);
    IgQ1_Temp = Igd1_Temp * sin(Delta_L1_Temp) + Igq1_Temp * cos(Delta_L1_Temp);
    IgDQ1_Vector = [IgD1_Temp; IgQ1_Temp];

    VgDQ1_Vector = iMc_Ynl * ( IgDQ1_Vector - Mb_Ynl * [VfDQ1_Vector; VfDQ2_Vector] );
    VgD1_Temp = VgDQ1_Vector(1);
    VgQ1_Temp = VgDQ1_Vector(2);
    Vgd1_Temp = VgD1_Temp * cos(Delta_L1_Temp) + VgQ1_Temp * sin(Delta_L1_Temp);
    Vgq1_Temp = -VgD1_Temp * sin(Delta_L1_Temp) + VgQ1_Temp * cos(Delta_L1_Temp);

    VfgDQ_Vector = [VfDQ1_Vector; VfDQ2_Vector; VgDQ1_Vector];
    IlDQ_Vector = Ma_Ynl * VfgDQ_Vector;
    IlD1_Temp = IlDQ_Vector(1);
    IlQ1_Temp = IlDQ_Vector(2);
    IlD2_Temp = IlDQ_Vector(3);
    IlQ2_Temp = IlDQ_Vector(4);

    Ild1_Temp = IlD1_Temp * cos(Delta_M1_Temp) + IlQ1_Temp * sin(Delta_M1_Temp);
    Ilq1_Temp = -IlD1_Temp * sin(Delta_M1_Temp) + IlQ1_Temp * cos(Delta_M1_Temp);
    Ild2_Temp = IlD2_Temp * cos(Delta_M2_Temp) + IlQ2_Temp * sin(Delta_M2_Temp);
    Ilq2_Temp = -IlD2_Temp * sin(Delta_M2_Temp) + IlQ2_Temp * cos(Delta_M2_Temp);

    p1_Temp = (3/2) * ( Vfd1_Temp * Ild1_Temp + Vfq1_Temp * Ilq1_Temp );
    q1_Temp = (3/2) * ( -Vfd1_Temp * Ilq1_Temp + Vfq1_Temp * Ild1_Temp );
    p2_Temp = (3/2) * ( Vfd2_Temp * Ild2_Temp + Vfq2_Temp * Ilq2_Temp );
    q2_Temp = (3/2) * ( -Vfd2_Temp * Ilq2_Temp + Vfq2_Temp * Ild2_Temp );

    DW1_PLL_Temp = kappa_p1 * Vgq1_Temp + kappa_i1 * Yomega1_Temp;

    if( Enable_PLL_Limit == 0 )
        % No Limit
        w_L1_Temp = DW1_PLL_Temp + w0;
    else
        % With Limit
        if( DW1_PLL_Temp > Sat_DW_PLL )
            w_L1_Temp = Sat_DW_PLL + w0;
        elseif( DW1_PLL_Temp < -Sat_DW_PLL )
            w_L1_Temp = -Sat_DW_PLL + w0;
        else
            w_L1_Temp = DW1_PLL_Temp + w0;
        end
    end

    % Differential coefficient
    DP1_Temp1 = wp1 * ( -P1_Temp + P01 - p1_Temp );
    DQ1_Temp1 = wq1 * ( -Q1_Temp + Q01 - q1_Temp );
    DP2_Temp1 = wp2 * ( -P2_Temp + P02 - p2_Temp );
    DQ2_Temp1 = wq2 * ( -Q2_Temp + Q02 - q2_Temp );
    D_Delta_M2_Temp1 = w_M2_Temp - w_M1_Temp;
    DVLm1_Temp1 = w_gama1 * ( Vgd1_Temp - VLm1_Temp );
    DYomega1_Temp1 = Vgq1_Temp;
    D_Delta_L1_Temp1 = w_L1_Temp - w_M1_Temp;
    
    % Step 2
    % State Variables
    P1_Temp = P1(i-1) + 0.5 * h * DP1_Temp1;
    Q1_Temp = Q1(i-1) + 0.5 * h * DQ1_Temp1;
    P2_Temp = P2(i-1) + 0.5 * h * DP2_Temp1;
    Q2_Temp = Q2(i-1) + 0.5 * h * DQ2_Temp1;
    Delta_M2_Temp = Delta_M2(i-1) + 0.5 * h * D_Delta_M2_Temp1;
    VLm1_Temp = VLm1(i-1) + 0.5 * h * DVLm1_Temp1;
    Yomega1_Temp = Yomega1(i-1) + 0.5 * h * DYomega1_Temp1;
    Delta_L1_Temp = Delta_L1(i-1) + 0.5 * h * D_Delta_L1_Temp1;
    
    % Other variables
    w_M1_Temp = w0 + mp1 * P1_Temp;
    Vfd1_Temp = V0 + nq1 * Q1_Temp;
    Vfq1_Temp = 0;
    w_M2_Temp = w0 + mp2 * P2_Temp;
    Vfd2_Temp = V0 + nq2 * Q2_Temp;
    Vfq2_Temp = 0;

    VfD1_Temp = Vfd1_Temp * cos(Delta_M1_Temp) - Vfq1_Temp * sin(Delta_M1_Temp);
    VfQ1_Temp = Vfd1_Temp * sin(Delta_M1_Temp) + Vfq1_Temp * cos(Delta_M1_Temp);
    VfD2_Temp = Vfd2_Temp * cos(Delta_M2_Temp) - Vfq2_Temp * sin(Delta_M2_Temp);
    VfQ2_Temp = Vfd2_Temp * sin(Delta_M2_Temp) + Vfq2_Temp * cos(Delta_M2_Temp);

    VfDQ1_Vector = [VfD1_Temp; VfQ1_Temp];
    VfDQ2_Vector = [VfD2_Temp; VfQ2_Temp];

    if( Sd1 == 1 )
        Igd1_Temp = Igd1_REF;
    else
        Igd1_Temp = P_GFL1 / ( 1.5 * VLm1_Temp );
    end

    if( Sq1 == 1 )
        Igq1_Temp = 0;
    elseif( Sq1 == 2 )
        Igq1_Temp = -Igq1_REF;
    elseif( Sq1 == 3 )
        Igq1_Temp = -Q_GFL1 / ( 1.5 * VLm1_Temp );
    else
        Igq1_Temp = -( Q_L01 + n_gama1 * ( V_L0 - VLm1_Temp ) ) / ( 1.5 * VLm1_Temp );
    end

    IgD1_Temp = Igd1_Temp * cos(Delta_L1_Temp) - Igq1_Temp * sin(Delta_L1_Temp);
    IgQ1_Temp = Igd1_Temp * sin(Delta_L1_Temp) + Igq1_Temp * cos(Delta_L1_Temp);
    IgDQ1_Vector = [IgD1_Temp; IgQ1_Temp];

    VgDQ1_Vector = iMc_Ynl * ( IgDQ1_Vector - Mb_Ynl * [VfDQ1_Vector; VfDQ2_Vector] );
    VgD1_Temp = VgDQ1_Vector(1);
    VgQ1_Temp = VgDQ1_Vector(2);
%     Vgd1_Temp = VgD1_Temp * cos(Delta_L1_Temp) + VgQ1_Temp * sin(Delta_L1_Temp);
    Vgq1_Temp = -VgD1_Temp * sin(Delta_L1_Temp) + VgQ1_Temp * cos(Delta_L1_Temp);

    VfgDQ_Vector = [VfDQ1_Vector; VfDQ2_Vector; VgDQ1_Vector];
    IlDQ_Vector = Ma_Ynl * VfgDQ_Vector;
    IlD1_Temp = IlDQ_Vector(1);
    IlQ1_Temp = IlDQ_Vector(2);
    IlD2_Temp = IlDQ_Vector(3);
    IlQ2_Temp = IlDQ_Vector(4);

    Ild1_Temp = IlD1_Temp * cos(Delta_M1_Temp) + IlQ1_Temp * sin(Delta_M1_Temp);
    Ilq1_Temp = -IlD1_Temp * sin(Delta_M1_Temp) + IlQ1_Temp * cos(Delta_M1_Temp);
    Ild2_Temp = IlD2_Temp * cos(Delta_M2_Temp) + IlQ2_Temp * sin(Delta_M2_Temp);
    Ilq2_Temp = -IlD2_Temp * sin(Delta_M2_Temp) + IlQ2_Temp * cos(Delta_M2_Temp);

    p1_Temp = (3/2) * ( Vfd1_Temp * Ild1_Temp + Vfq1_Temp * Ilq1_Temp );
    q1_Temp = (3/2) * ( -Vfd1_Temp * Ilq1_Temp + Vfq1_Temp * Ild1_Temp );
    p2_Temp = (3/2) * ( Vfd2_Temp * Ild2_Temp + Vfq2_Temp * Ilq2_Temp );
    q2_Temp = (3/2) * ( -Vfd2_Temp * Ilq2_Temp + Vfq2_Temp * Ild2_Temp );

    DW1_PLL_Temp = kappa_p1 * Vgq1_Temp + kappa_i1 * Yomega1_Temp;

    if( Enable_PLL_Limit == 0 )
        % No Limit
        w_L1_Temp = DW1_PLL_Temp + w0;
    else
        % With Limit
        if( DW1_PLL_Temp > Sat_DW_PLL )
            w_L1_Temp = Sat_DW_PLL + w0;
        elseif( DW1_PLL_Temp < -Sat_DW_PLL )
            w_L1_Temp = -Sat_DW_PLL + w0;
        else
            w_L1_Temp = DW1_PLL_Temp + w0;
        end
    end

    % Differential coefficient
    DP1_Temp2 = wp1 * ( -P1_Temp + P01 - p1_Temp );
    DQ1_Temp2 = wq1 * ( -Q1_Temp + Q01 - q1_Temp );
    DP2_Temp2 = wp2 * ( -P2_Temp + P02 - p2_Temp );
    DQ2_Temp2 = wq2 * ( -Q2_Temp + Q02 - q2_Temp );
    D_Delta_M2_Temp2 = w_M2_Temp - w_M1_Temp;
    DVLm1_Temp2 = w_gama1 * ( Vgd1_Temp - VLm1_Temp );
    DYomega1_Temp2 = Vgq1_Temp;
    D_Delta_L1_Temp2 = w_L1_Temp - w_M1_Temp;

    % Step 3
    % State Variables
    P1_Temp = P1(i-1) + 0.5 * h * DP1_Temp2;
    Q1_Temp = Q1(i-1) + 0.5 * h * DQ1_Temp2;
    P2_Temp = P2(i-1) + 0.5 * h * DP2_Temp2;
    Q2_Temp = Q2(i-1) + 0.5 * h * DQ2_Temp2;
    Delta_M2_Temp = Delta_M2(i-1) + 0.5 * h * D_Delta_M2_Temp2;
    VLm1_Temp = VLm1(i-1) + 0.5 * h * DVLm1_Temp2;
    Yomega1_Temp = Yomega1(i-1) + 0.5 * h * DYomega1_Temp2;
    Delta_L1_Temp = Delta_L1(i-1) + 0.5 * h * D_Delta_L1_Temp2;

    % Other variables
    w_M1_Temp = w0 + mp1 * P1_Temp;
    Vfd1_Temp = V0 + nq1 * Q1_Temp;
    Vfq1_Temp = 0;
    w_M2_Temp = w0 + mp2 * P2_Temp;
    Vfd2_Temp = V0 + nq2 * Q2_Temp;
    Vfq2_Temp = 0;

    VfD1_Temp = Vfd1_Temp * cos(Delta_M1_Temp) - Vfq1_Temp * sin(Delta_M1_Temp);
    VfQ1_Temp = Vfd1_Temp * sin(Delta_M1_Temp) + Vfq1_Temp * cos(Delta_M1_Temp);
    VfD2_Temp = Vfd2_Temp * cos(Delta_M2_Temp) - Vfq2_Temp * sin(Delta_M2_Temp);
    VfQ2_Temp = Vfd2_Temp * sin(Delta_M2_Temp) + Vfq2_Temp * cos(Delta_M2_Temp);

    VfDQ1_Vector = [VfD1_Temp; VfQ1_Temp];
    VfDQ2_Vector = [VfD2_Temp; VfQ2_Temp];

    if( Sd1 == 1 )
        Igd1_Temp = Igd1_REF;
    else
        Igd1_Temp = P_GFL1 / ( 1.5 * VLm1_Temp );
    end

    if( Sq1 == 1 )
        Igq1_Temp = 0;
    elseif( Sq1 == 2 )
        Igq1_Temp = -Igq1_REF;
    elseif( Sq1 == 3 )
        Igq1_Temp = -Q_GFL1 / ( 1.5 * VLm1_Temp );
    else
        Igq1_Temp = -( Q_L01 + n_gama1 * ( V_L0 - VLm1_Temp ) ) / ( 1.5 * VLm1_Temp );
    end

    IgD1_Temp = Igd1_Temp * cos(Delta_L1_Temp) - Igq1_Temp * sin(Delta_L1_Temp);
    IgQ1_Temp = Igd1_Temp * sin(Delta_L1_Temp) + Igq1_Temp * cos(Delta_L1_Temp);
    IgDQ1_Vector = [IgD1_Temp; IgQ1_Temp];

    VgDQ1_Vector = iMc_Ynl * ( IgDQ1_Vector - Mb_Ynl * [VfDQ1_Vector; VfDQ2_Vector] );
    VgD1_Temp = VgDQ1_Vector(1);
    VgQ1_Temp = VgDQ1_Vector(2);
%     Vgd1_Temp = VgD1_Temp * cos(Delta_L1_Temp) + VgQ1_Temp * sin(Delta_L1_Temp);
    Vgq1_Temp = -VgD1_Temp * sin(Delta_L1_Temp) + VgQ1_Temp * cos(Delta_L1_Temp);

    VfgDQ_Vector = [VfDQ1_Vector; VfDQ2_Vector; VgDQ1_Vector];
    IlDQ_Vector = Ma_Ynl * VfgDQ_Vector;
    IlD1_Temp = IlDQ_Vector(1);
    IlQ1_Temp = IlDQ_Vector(2);
    IlD2_Temp = IlDQ_Vector(3);
    IlQ2_Temp = IlDQ_Vector(4);

    Ild1_Temp = IlD1_Temp * cos(Delta_M1_Temp) + IlQ1_Temp * sin(Delta_M1_Temp);
    Ilq1_Temp = -IlD1_Temp * sin(Delta_M1_Temp) + IlQ1_Temp * cos(Delta_M1_Temp);
    Ild2_Temp = IlD2_Temp * cos(Delta_M2_Temp) + IlQ2_Temp * sin(Delta_M2_Temp);
    Ilq2_Temp = -IlD2_Temp * sin(Delta_M2_Temp) + IlQ2_Temp * cos(Delta_M2_Temp);

    p1_Temp = (3/2) * ( Vfd1_Temp * Ild1_Temp + Vfq1_Temp * Ilq1_Temp );
    q1_Temp = (3/2) * ( -Vfd1_Temp * Ilq1_Temp + Vfq1_Temp * Ild1_Temp );
    p2_Temp = (3/2) * ( Vfd2_Temp * Ild2_Temp + Vfq2_Temp * Ilq2_Temp );
    q2_Temp = (3/2) * ( -Vfd2_Temp * Ilq2_Temp + Vfq2_Temp * Ild2_Temp );

    DW1_PLL_Temp = kappa_p1 * Vgq1_Temp + kappa_i1 * Yomega1_Temp;

    if( Enable_PLL_Limit == 0 )
        % No Limit
        w_L1_Temp = DW1_PLL_Temp + w0;
    else
        % With Limit
        if( DW1_PLL_Temp > Sat_DW_PLL )
            w_L1_Temp = Sat_DW_PLL + w0;
        elseif( DW1_PLL_Temp < -Sat_DW_PLL )
            w_L1_Temp = -Sat_DW_PLL + w0;
        else
            w_L1_Temp = DW1_PLL_Temp + w0;
        end
    end

    % Differential coefficient
    DP1_Temp3 = wp1 * ( -P1_Temp + P01 - p1_Temp );
    DQ1_Temp3 = wq1 * ( -Q1_Temp + Q01 - q1_Temp );
    DP2_Temp3 = wp2 * ( -P2_Temp + P02 - p2_Temp );
    DQ2_Temp3 = wq2 * ( -Q2_Temp + Q02 - q2_Temp );
    D_Delta_M2_Temp3 = w_M2_Temp - w_M1_Temp;
    DVLm1_Temp3 = w_gama1 * ( Vgd1_Temp - VLm1_Temp );
    DYomega1_Temp3 = Vgq1_Temp;
    D_Delta_L1_Temp3 = w_L1_Temp - w_M1_Temp;

    % Step 4
    % State Variables
    P1_Temp = P1(i-1) + h * DP1_Temp3;
    Q1_Temp = Q1(i-1) + h * DQ1_Temp3;
    P2_Temp = P2(i-1) + h * DP2_Temp3;
    Q2_Temp = Q2(i-1) + h * DQ2_Temp3;
    Delta_M2_Temp = Delta_M2(i-1) + h * D_Delta_M2_Temp3;
    VLm1_Temp = VLm1(i-1) + h * DVLm1_Temp3;
    Yomega1_Temp = Yomega1(i-1) + h * DYomega1_Temp3;
    Delta_L1_Temp = Delta_L1(i-1) + h * D_Delta_L1_Temp3;

    % Other variables
    w_M1_Temp = w0 + mp1 * P1_Temp;
    Vfd1_Temp = V0 + nq1 * Q1_Temp;
    Vfq1_Temp = 0;
    w_M2_Temp = w0 + mp2 * P2_Temp;
    Vfd2_Temp = V0 + nq2 * Q2_Temp;
    Vfq2_Temp = 0;

    VfD1_Temp = Vfd1_Temp * cos(Delta_M1_Temp) - Vfq1_Temp * sin(Delta_M1_Temp);
    VfQ1_Temp = Vfd1_Temp * sin(Delta_M1_Temp) + Vfq1_Temp * cos(Delta_M1_Temp);
    VfD2_Temp = Vfd2_Temp * cos(Delta_M2_Temp) - Vfq2_Temp * sin(Delta_M2_Temp);
    VfQ2_Temp = Vfd2_Temp * sin(Delta_M2_Temp) + Vfq2_Temp * cos(Delta_M2_Temp);

    VfDQ1_Vector = [VfD1_Temp; VfQ1_Temp];
    VfDQ2_Vector = [VfD2_Temp; VfQ2_Temp];

    if( Sd1 == 1 )
        Igd1_Temp = Igd1_REF;
    else
        Igd1_Temp = P_GFL1 / ( 1.5 * VLm1_Temp );
    end

    if( Sq1 == 1 )
        Igq1_Temp = 0;
    elseif( Sq1 == 2 )
        Igq1_Temp = -Igq1_REF;
    elseif( Sq1 == 3 )
        Igq1_Temp = -Q_GFL1 / ( 1.5 * VLm1_Temp );
    else
        Igq1_Temp = -( Q_L01 + n_gama1 * ( V_L0 - VLm1_Temp ) ) / ( 1.5 * VLm1_Temp );
    end

    IgD1_Temp = Igd1_Temp * cos(Delta_L1_Temp) - Igq1_Temp * sin(Delta_L1_Temp);
    IgQ1_Temp = Igd1_Temp * sin(Delta_L1_Temp) + Igq1_Temp * cos(Delta_L1_Temp);
    IgDQ1_Vector = [IgD1_Temp; IgQ1_Temp];

    VgDQ1_Vector = iMc_Ynl * ( IgDQ1_Vector - Mb_Ynl * [VfDQ1_Vector; VfDQ2_Vector] );
    VgD1_Temp = VgDQ1_Vector(1);
    VgQ1_Temp = VgDQ1_Vector(2);
%     Vgd1_Temp = VgD1_Temp * cos(Delta_L1_Temp) + VgQ1_Temp * sin(Delta_L1_Temp);
    Vgq1_Temp = -VgD1_Temp * sin(Delta_L1_Temp) + VgQ1_Temp * cos(Delta_L1_Temp);

    VfgDQ_Vector = [VfDQ1_Vector; VfDQ2_Vector; VgDQ1_Vector];
    IlDQ_Vector = Ma_Ynl * VfgDQ_Vector;
    IlD1_Temp = IlDQ_Vector(1);
    IlQ1_Temp = IlDQ_Vector(2);
    IlD2_Temp = IlDQ_Vector(3);
    IlQ2_Temp = IlDQ_Vector(4);

    Ild1_Temp = IlD1_Temp * cos(Delta_M1_Temp) + IlQ1_Temp * sin(Delta_M1_Temp);
    Ilq1_Temp = -IlD1_Temp * sin(Delta_M1_Temp) + IlQ1_Temp * cos(Delta_M1_Temp);
    Ild2_Temp = IlD2_Temp * cos(Delta_M2_Temp) + IlQ2_Temp * sin(Delta_M2_Temp);
    Ilq2_Temp = -IlD2_Temp * sin(Delta_M2_Temp) + IlQ2_Temp * cos(Delta_M2_Temp);

    p1_Temp = (3/2) * ( Vfd1_Temp * Ild1_Temp + Vfq1_Temp * Ilq1_Temp );
    q1_Temp = (3/2) * ( -Vfd1_Temp * Ilq1_Temp + Vfq1_Temp * Ild1_Temp );
    p2_Temp = (3/2) * ( Vfd2_Temp * Ild2_Temp + Vfq2_Temp * Ilq2_Temp );
    q2_Temp = (3/2) * ( -Vfd2_Temp * Ilq2_Temp + Vfq2_Temp * Ild2_Temp );

    DW1_PLL_Temp = kappa_p1 * Vgq1_Temp + kappa_i1 * Yomega1_Temp;

    if( Enable_PLL_Limit == 0 )
        % No Limit
        w_L1_Temp = DW1_PLL_Temp + w0;
    else
        % With Limit
        if( DW1_PLL_Temp > Sat_DW_PLL )
            w_L1_Temp = Sat_DW_PLL + w0;
        elseif( DW1_PLL_Temp < -Sat_DW_PLL )
            w_L1_Temp = -Sat_DW_PLL + w0;
        else
            w_L1_Temp = DW1_PLL_Temp + w0;
        end
    end

    % Differential coefficient
    DP1_Temp4 = wp1 * ( -P1_Temp + P01 - p1_Temp );
    DQ1_Temp4 = wq1 * ( -Q1_Temp + Q01 - q1_Temp );
    DP2_Temp4 = wp2 * ( -P2_Temp + P02 - p2_Temp );
    DQ2_Temp4 = wq2 * ( -Q2_Temp + Q02 - q2_Temp );
    D_Delta_M2_Temp4 = w_M2_Temp - w_M1_Temp;
    DVLm1_Temp4 = w_gama1 * ( Vgd1_Temp - VLm1_Temp );
    DYomega1_Temp4 = Vgq1_Temp;
    D_Delta_L1_Temp4 = w_L1_Temp - w_M1_Temp;

    % Summary
    % State variables
    P1(i) = P1(i-1) + (1/6) * h * ( DP1_Temp1 + 2 * DP1_Temp2 + 2 * DP1_Temp3 + DP1_Temp4 );
    Q1(i) = Q1(i-1) + (1/6) * h * ( DQ1_Temp1 + 2 * DQ1_Temp2 + 2 * DQ1_Temp3 + DQ1_Temp4 );
    P2(i) = P2(i-1) + (1/6) * h * ( DP2_Temp1 + 2 * DP2_Temp2 + 2 * DP2_Temp3 + DP2_Temp4 );
    Q2(i) = Q2(i-1) + (1/6) * h * ( DQ2_Temp1 + 2 * DQ2_Temp2 + 2 * DQ2_Temp3 + DQ2_Temp4 );
    Delta_M2(i) = Delta_M2(i-1) + (1/6) * h * ( D_Delta_M2_Temp1 + 2 * D_Delta_M2_Temp2 + 2 * D_Delta_M2_Temp3 + D_Delta_M2_Temp4 );
    VLm1(i) = VLm1(i-1) + (1/6) * h * ( DVLm1_Temp1 + 2 * DVLm1_Temp2 + 2 * DVLm1_Temp3 + DVLm1_Temp4 );
    Yomega1(i) = Yomega1(i-1) + (1/6) * h * ( DYomega1_Temp1 + 2 * DYomega1_Temp2 + 2 * DYomega1_Temp3 + DYomega1_Temp4 );
    Delta_L1(i) = Delta_L1(i-1) + (1/6) * h * ( D_Delta_L1_Temp1 + 2 * D_Delta_L1_Temp2 + 2 * D_Delta_L1_Temp3 + D_Delta_L1_Temp4 );
    
    % Other variables
    w_M1(i) = w0 + mp1 * P1(i);
    Vfd1(i) = V0 + nq1 * Q1(i);
%     Vfq1(i) = 0;
    w_M2(i) = w0 + mp2 * P2(i);
    Vfd2(i) = V0 + nq2 * Q2(i);
%     Vfq2(i) = 0;

    VfD1(i) = Vfd1(i) * cos(Delta_M1(i)) - Vfq1(i) * sin(Delta_M1(i));
    VfQ1(i) = Vfd1(i) * sin(Delta_M1(i)) + Vfq1(i) * cos(Delta_M1(i));
    VfD2(i) = Vfd2(i) * cos(Delta_M2(i)) - Vfq2(i) * sin(Delta_M2(i));
    VfQ2(i) = Vfd2(i) * sin(Delta_M2(i)) + Vfq2(i) * cos(Delta_M2(i));

    VfDQ1_Vector = [VfD1(i); VfQ1(i)];
    VfDQ2_Vector = [VfD2(i); VfQ2(i)];

    if( Sd1 == 1 )
        Igd1(i) = Igd1_REF;
    else
        Igd1(i) = P_GFL1 / ( 1.5 * VLm1(i) );
    end

    if( Sq1 == 1 )
        Igq1(i) = 0;
    elseif( Sq1 == 2 )
        Igq1(i) = -Igq1_REF;
    elseif( Sq1 == 3 )
        Igq1(i) = -Q_GFL1 / ( 1.5 * VLm1(i) );
    else
        Igq1(i) = -( Q_L01 + n_gama1 * ( V_L0 - VLm1(i) ) ) / ( 1.5 * VLm1(i) );
    end

    IgD1(i) = Igd1(i) * cos(Delta_L1(i)) - Igq1(i) * sin(Delta_L1(i));
    IgQ1(i) = Igd1(i) * sin(Delta_L1(i)) + Igq1(i) * cos(Delta_L1(i));
    IgDQ1_Vector = [IgD1(i); IgQ1(i)];

    VgDQ1_Vector = iMc_Ynl * ( IgDQ1_Vector - Mb_Ynl * [VfDQ1_Vector; VfDQ2_Vector] );
    VgD1(i) = VgDQ1_Vector(1);
    VgQ1(i) = VgDQ1_Vector(2);
    Vgd1(i) = VgD1(i) * cos(Delta_L1(i)) + VgQ1(i) * sin(Delta_L1(i));
    Vgq1(i) = -VgD1(i) * sin(Delta_L1(i)) + VgQ1(i) * cos(Delta_L1(i));

    VfgDQ_Vector = [VfDQ1_Vector; VfDQ2_Vector; VgDQ1_Vector];
    IlDQ_Vector = Ma_Ynl * VfgDQ_Vector;
    IlD1(i) = IlDQ_Vector(1);
    IlQ1(i) = IlDQ_Vector(2);
    IlD2(i) = IlDQ_Vector(3);
    IlQ2(i) = IlDQ_Vector(4);

    Ild1(i) = IlD1(i) * cos(Delta_M1(i)) + IlQ1(i) * sin(Delta_M1(i));
    Ilq1(i) = -IlD1(i) * sin(Delta_M1(i)) + IlQ1(i) * cos(Delta_M1(i));
    Ild2(i) = IlD2(i) * cos(Delta_M2(i)) + IlQ2(i) * sin(Delta_M2(i));
    Ilq2(i) = -IlD2(i) * sin(Delta_M2(i)) + IlQ2(i) * cos(Delta_M2(i));

    p1(i) = (3/2) * ( Vfd1(i) * Ild1(i) + Vfq1(i) * Ilq1(i) );
    q1(i) = (3/2) * ( -Vfd1(i) * Ilq1(i) + Vfq1(i) * Ild1(i) );
    p2(i) = (3/2) * ( Vfd2(i) * Ild2(i) + Vfq2(i) * Ilq2(i) );
    q2(i) = (3/2) * ( -Vfd2(i) * Ilq2(i) + Vfq2(i) * Ild2(i) );

    DW1_PLL(i) = kappa_p1 * Vgq1(i) + kappa_i1 * Yomega1(i);

    if( Enable_PLL_Limit == 0 )
        % No Limit
        w_L1(i) = DW1_PLL(i) + w0;
    else
        % With Limit
        if( DW1_PLL(i) > Sat_DW_PLL )
            w_L1(i) = Sat_DW_PLL + w0;
            Sign_DW1_Sat = 1;
        elseif( DW1_PLL(i) < -Sat_DW_PLL )
            w_L1(i) = -Sat_DW_PLL + w0;
            Sign_DW1_Sat = 1;
        else
            w_L1(i) = DW1_PLL(i) + w0;
            Sign_DW1_Sat = 0;
        end
    end

    if( Enable_PLL_Limit == 2 )
        % Adaptive limit
        if( Sign_DW1_Sat ~= Sign_DW1_Sat_Last )
            if( Sign_DW1_Sat == 1 )
                % From 0 to 1
                Sat_DW_PLL = Sat_DW_PLL_Fnl;
                Cnt_DW_SatChg = 0;
                Sign_DW1_Sat_Last = Sign_DW1_Sat;
            else
                % From 1 to 0
                if( Cnt_DW_SatChg < Num_DW_SatChg )
                    Cnt_DW_SatChg = Cnt_DW_SatChg + 1;
                else
                    Sat_DW_PLL = Sat_DW_PLL_Int;
                    Sign_DW1_Sat_Last = Sign_DW1_Sat;
                end
            end
        end
    end
    
    % Time array
    Time(i) = Time(i-1) + h;
    
    % Transform
    if( ( Delta_M2(i) < 0 ) || ( Delta_M2(i) > 2*pi ) )
        Delta_M2_SR(i) = Delta_M2(i) - floor(Delta_M2(i)/(2*pi)) * (2*pi);
    else
        Delta_M2_SR(i) = Delta_M2(i);
    end
    
    if( Delta_M2_SR(i) > pi )
        Delta_M2_SR(i) = Delta_M2_SR(i) - 2*pi;
    end

    if( ( Delta_L1(i) < 0 ) || ( Delta_L1(i) > 2*pi ) )
        Delta_L1_SR(i) = Delta_L1(i) - floor(Delta_L1(i)/(2*pi)) * (2*pi);
    else
        Delta_L1_SR(i) = Delta_L1(i);
    end
    
    if( Delta_L1_SR(i) > pi )
        Delta_L1_SR(i) = Delta_L1_SR(i) - 2*pi;
    end

    % Recongize the effective passing
    if( i > Recog_Start_Num )
        if( ( ( Delta_M2_SR(i) > pi/2 ) && ( Delta_M2_SR(i-1) < -pi/2 ) ) || ( ( Delta_M2_SR(i) < -pi/2 ) && ( Delta_M2_SR(i-1) > pi/2 ) ) )
            Pass_Cnt(1) = Pass_Cnt(1) + 1;
        end

        if( ( ( Delta_L1_SR(i) > pi/2 ) && ( Delta_L1_SR(i-1) < -pi/2 ) ) || ( ( Delta_L1_SR(i) < -pi/2 ) && ( Delta_L1_SR(i-1) > pi/2 ) ) )
            Pass_Cnt(2) = Pass_Cnt(2) + 1;
        end
    end
end

% Effective passing
for j = 1 : 2
    if( Pass_Cnt(j) >= Eff_Pass_Num )
        Eff_Pass_Sign(j) = 1;
    end
end





