
% clear
clear
close all


% Default parameters
Input_Parameters_V6_2
Network_Matrix_V2

% Critical Parameters
Sd1 = 2;                            % 1: Constant current; 2: Constant power
Sq1 = 3;                            % 1: No reactive current/power; 2: Constant current; 3: Constant power; 4: Droop

Enable_PLL_Limit = 2;               % 0: No Limit; 1: With fixed limit; 2: Adaptive limit
Sat_DW_PLL_Fixed = 2*pi*2;          % Effective for Enable_PLL_Limit = 1


% Derive SEP
Derive_SEP_V3_1
Derive_UEP_V4_1

% Running Time
Tal_Time = 10;


% Array Define
Array_Delta_L1 = (-pi:0.02*pi:3*pi);        % Resolution of the derived figure. For high resolution, the computation time is long.
Array_Y_Omega1 = (-40:0.5:40);

Num_Arr_Delta_L1 = length(Array_Delta_L1);
Num_Arr_Y_Omega1 = length(Array_Y_Omega1);

Sign_BofA = zeros(Num_Arr_Delta_L1,Num_Arr_Y_Omega1);


% Derive
for Cnt2 = 1 : Num_Arr_Y_Omega1
    for Cnt1 = 1 : Num_Arr_Delta_L1
        % Input
        Initial.P1 = EQP1(1);
        Initial.Q1 = EQP1(2);
        Initial.P2 = EQP1(3);
        Initial.Q2 = EQP1(4);
        Initial.Delta_M2 = EQP1(5);
        Initial.VLm1 = EQP1(6);
        Initial.Yomega1 = Array_Y_Omega1(Cnt2);
        Initial.Delta_L1 = Array_Delta_L1(Cnt1);
        
        % RK Algorithm
        Derive_Trajectory_V6_2

        % Judge
        if( ( Eff_Pass_Sign(1) == 0 ) && ( Eff_Pass_Sign(2) == 0 ) )
            % Converge to SEP
            Sign_BofA(Cnt1,Cnt2) = 0;
        elseif( ( Eff_Pass_Sign(1) == 0 ) && ( Eff_Pass_Sign(2) == 1 ) )
            % Oscillating Delta_L1
            Sign_BofA(Cnt1,Cnt2) = 1;
        elseif( ( Eff_Pass_Sign(1) == 1 ) && ( Eff_Pass_Sign(2) == 1 ) )
            % Oscillating Delta_M2 & Delta_L1
            Sign_BofA(Cnt1,Cnt2) = 2;
        else
            Sign_BofA(Cnt1,Cnt2) = 3;
        end
    end
end


% Plot
figure(1);
for Cnt2 = 1 : Num_Arr_Y_Omega1
    for Cnt1 = 1 : Num_Arr_Delta_L1
        if( Sign_BofA(Cnt1,Cnt2) == 0 )
            % Converge to SEP
            plot(Array_Delta_L1(Cnt1),Array_Y_Omega1(Cnt2),'c','LineWidth',1.5,'LineStyle','none','Marker','.');
            hold on;
        elseif( Sign_BofA(Cnt1,Cnt2) == 1 )
            % Oscillating Delta_L1
            plot(Array_Delta_L1(Cnt1),Array_Y_Omega1(Cnt2),'w','LineWidth',1.5,'LineStyle','none','Marker','.');
            hold on;
        elseif( Sign_BofA(Cnt1,Cnt2) == 2 )
            % Oscillating Delta_M2 & Delta_L1
            plot(Array_Delta_L1(Cnt1),Array_Y_Omega1(Cnt2),'m','LineWidth',1.5,'LineStyle','none','Marker','.');
            hold on;
        else
            plot(Array_Delta_L1(Cnt1),Array_Y_Omega1(Cnt2),'k','LineWidth',1.5,'LineStyle','none','Marker','.');
            hold on;
        end
    end
end
plot(EQP1(8),EQP1(7),'color','#EDB120','LineWidth',1.5,'LineStyle','none','Marker','o');
hold on;
plot(EQP2(8),EQP2(7),'color','#A2142F','LineWidth',1.5,'LineStyle','none','Marker','o');
hold on;
plot(EQP1(8)+2*pi,EQP1(7),'color','#EDB120','LineWidth',1.5,'LineStyle','none','Marker','o');
hold on;
plot(EQP2(8)+2*pi,EQP2(7),'color','#A2142F','LineWidth',1.5,'LineStyle','none','Marker','o');
% grid on;
xlabel('Delta,L1','FontName','Times New Roman','FontSize',12,'FontWeight','bold');
ylabel('Yomega1','FontName','Times New Roman','FontSize',12,'FontWeight','bold');
axis([-pi,3*pi,-40,40]);
xticks([-pi 0 pi 2*pi 3*pi]);
yticks([-40 -20 0 20 40]);




