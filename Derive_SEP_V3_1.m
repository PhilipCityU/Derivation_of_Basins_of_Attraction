
% Define
syms p1 q1 p2 q2 Delta_M2 V_gd1 Delta_L1

syms Delta_M1
syms P1 Q1 w_M1
syms P2 Q2 w_M2
syms V_fd1 V_fq1 V_fD1 V_fQ1
syms V_fd2 V_fq2 V_fD2 V_fQ2 
syms V_gq1 V_gD1 V_gQ1
syms I_gd1 I_gq1 I_gD1 I_gQ1
syms I_ld1 I_lq1 I_lD1 I_lQ1
syms I_ld2 I_lq2 I_lD2 I_lQ2

syms f1 f2 f3 f4 f5 f6 f7

P1 = P01 - p1;
Q1 = Q01 - q1;
P2 = P02 - p2;
Q2 = Q02 - q2;

Delta_M1 = 0;
w_M1 = w0 + mp1 * P1;
V_fd1 = V0 + nq1 * Q1;
V_fq1 = 0;
w_M2 = w0 + mp2 * P2;
V_fd2 = V0 + nq2 * Q2;
V_fq2 = 0;

V_fD1 = V_fd1 * cos(Delta_M1) - V_fq1 * sin(Delta_M1);
V_fQ1 = V_fd1 * sin(Delta_M1) + V_fq1 * cos(Delta_M1);
V_fD2 = V_fd2 * cos(Delta_M2) - V_fq2 * sin(Delta_M2);
V_fQ2 = V_fd2 * sin(Delta_M2) + V_fq2 * cos(Delta_M2);

V_gq1 = 0;
V_gD1 = V_gd1 * cos(Delta_L1) - V_gq1 * sin(Delta_L1);
V_gQ1 = V_gd1 * sin(Delta_L1) + V_gq1 * cos(Delta_L1);

VfDQ1_Vector = [V_fD1; V_fQ1];
VfDQ2_Vector = [V_fD2; V_fQ2];
VgDQ1_Vector = [V_gD1; V_gQ1];
VfgDQ_Vector = [VfDQ1_Vector; VfDQ2_Vector; VgDQ1_Vector];
IlgDQ_Vector = M_Ynl * VfgDQ_Vector;

I_lD1 = IlgDQ_Vector(1);
I_lQ1 = IlgDQ_Vector(2);
I_lD2 = IlgDQ_Vector(3);
I_lQ2 = IlgDQ_Vector(4);
I_gD1 = IlgDQ_Vector(5);
I_gQ1 = IlgDQ_Vector(6);

I_gd1 = I_gD1 * cos(Delta_L1) + I_gQ1 * sin(Delta_L1);
I_gq1 = -I_gD1 * sin(Delta_L1) + I_gQ1 * cos(Delta_L1);

I_ld1 = I_lD1 * cos(Delta_M1) + I_lQ1 * sin(Delta_M1);
I_lq1 = -I_lD1 * sin(Delta_M1) + I_lQ1 * cos(Delta_M1);
I_ld2 = I_lD2 * cos(Delta_M2) + I_lQ2 * sin(Delta_M2);
I_lq2 = -I_lD2 * sin(Delta_M2) + I_lQ2 * cos(Delta_M2);


f1 = p1 - (3/2) * ( V_fd1 * I_ld1 + V_fq1 * I_lq1 );
f2 = q1 - (3/2) * ( -V_fd1 * I_lq1 + V_fq1 * I_ld1 );

f3 = p2 - (3/2) * ( V_fd2 * I_ld2 + V_fq2 * I_lq2 );
f4 = q2 - (3/2) * ( -V_fd2 * I_lq2 + V_fq2 * I_ld2 );

f5 = w_M2 - w_M1;

f6 = I_gd1 - P_GFL1 / ( 1.5 * V_gd1 );

if( Sq1 == 1 )
    f7 = I_gq1;
elseif( Sq1 == 2 )
    f7 = I_gq1 + Igq1_REF;
elseif( Sq1 == 3 )
    f7 = I_gq1 + Q_GFL1 / ( 1.5 * V_gd1 );
else
    f7 = I_gq1 + ( Q_L01 + n_gama1 * ( V_L0 - V_gd1 ) ) / ( 1.5 * V_gd1 );
end

f_Vector = [f1; f2; f3; f4; f5; f6; f7];


% The first derivates of f
for j = 1 : 7
    df_Matrix(j,1) = diff(f_Vector(j),p1,1);
    df_Matrix(j,2) = diff(f_Vector(j),q1,1);

    df_Matrix(j,3) = diff(f_Vector(j),p2,1);
    df_Matrix(j,4) = diff(f_Vector(j),q2,1);
    df_Matrix(j,5) = diff(f_Vector(j),Delta_M2,1);

    df_Matrix(j,6) = diff(f_Vector(j),V_gd1,1);
    df_Matrix(j,7) = diff(f_Vector(j),Delta_L1,1);
end


% Using Newton's method
% Allowed eror
err = 1e-5;

% Define
Num = 15;
X = zeros(7,Num);
X_Vector = zeros(7,1);
X_Vector_New = zeros(7,1);
df_Matrix_Value = zeros(7,7);
EQP1 = zeros(8,1);

Err_Cacu = 0;

% Initial Values
X(:,1) = [3.11e4; 5.89e3; 1.55e4; 1.36e4; -0.2742; 252.7969; -0.1845];

% Iteration
for j = 2 : Num
    % Result in last turn
    X_Vector = X(:,j-1);
    
    % Jacobian
    df_Matrix_Value = subs(df_Matrix,[p1; q1; p2; q2; Delta_M2; V_gd1; Delta_L1], X_Vector);
    df_Matrix_Value = double( vpa( df_Matrix_Value ) );
    
    % New estimation result
    Temp_Vector = subs(f_Vector,[p1; q1; p2; q2; Delta_M2; V_gd1; Delta_L1], X_Vector);
    Temp_Vector = double( vpa( Temp_Vector ) );
    X_Vector_New = X_Vector - df_Matrix_Value \ Temp_Vector;
        
    % Error calculation
    Err_Cacu = 0;
    
    for i = 1 : 7
        Err_Cacu = Err_Cacu + ( X_Vector_New(i) - X_Vector(i) )^2;
    end
    
    Err_Cacu = sqrt(Err_Cacu);
    
    % Judge according to the error
    if( Err_Cacu < err )
        X_Vector_New = double( vpa(X_Vector_New) );
        X(:,j) = X_Vector_New;

        Result.p1 = X_Vector_New(1);
        Result.q1 = X_Vector_New(2);
        Result.p2 = X_Vector_New(3);
        Result.q2 = X_Vector_New(4);
        Result.Delta_M2 = X_Vector_New(5);
        Result.V_gd1 = X_Vector_New(6);
        Result.Delta_L1 = X_Vector_New(7);

        Result.P1 = P01 - Result.p1;
        Result.Q1 = Q01 - Result.q1;
        Result.P2 = P02 - Result.p2;
        Result.Q2 = Q02 - Result.q2;

        Result.Delta_M1 = 0;
        Result.w_M1 = w0 + mp1 * Result.P1;
        Result.w_L1 = Result.w_M1;
        Result.y_w1 = ( Result.w_L1 - w0 ) / kappa_i1;

        if( ( Result.Delta_M2 < 0 ) || ( Result.Delta_M2 > 2*pi ) )
            Result.Delta_M2 = Result.Delta_M2 - floor(Result.Delta_M2/(2*pi)) * (2*pi);
        else
            Result.Delta_M2 = Result.Delta_M2;
        end

        if( Result.Delta_M2 > pi )
            Result.Delta_M2 = Result.Delta_M2 - 2*pi;
        end

        if( ( Result.Delta_L1 < 0 ) || ( Result.Delta_L1 > 2*pi ) )
            Result.Delta_L1 = Result.Delta_L1 - floor(Result.Delta_L1/(2*pi)) * (2*pi);
        else
            Result.Delta_L1 = Result.Delta_L1;
        end

        if( Result.Delta_L1 > pi )
            Result.Delta_L1 = Result.Delta_L1 - 2*pi;
        end

        
        % EQP values
        EQP1(1) = Result.P1;
        EQP1(2) = Result.Q1;
        EQP1(3) = Result.P2;
        EQP1(4) = Result.Q2;
        EQP1(5) = Result.Delta_M2;
        EQP1(6) = Result.V_gd1;
        EQP1(7) = Result.y_w1;
        EQP1(8) = Result.Delta_L1;

        break;
    else
        X_Vector_New = double( vpa(X_Vector_New) );
        X(:,j) = X_Vector_New;
    end
end

% Check
if( j >= Num )
    error('Error! Beyond the allowable iteration number!');
end





