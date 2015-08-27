% Prob 1.

%*************************************************************************
% Plant Model
%*************************************************************************
% State Names 
%  -----------
%  AZ fps2         
%  q rps           
%  Dele deg        
%  Dele dot dps    
%  Input Names
%  -----------
%  Dele cmd deg    
Ap = [  -1.3046     1
        47.711      0];
Bp = [ -0.2142; -104.8346];
Cp = [  -1156.9  0;
        0        1];
Dp = [189.9483;
        0];


%*******************************************************
% Static Output Feedback With New Form To Test Prior To Substituting 
% The Big Plant Model
%*******************************************************  
% Close the loop to test the model
% Plant form  xdot = Apx + Bpu; y = Cpx +Dpu
% Controller xcdot = Acxc + Bc1y + Bc2r
%                      u = Ccxc + Dc1y + Dc2r
Ac = [ 0    0;
      -1.92 0];
Bc1 = [0.003    0;
      -0.0029   1.92];
Bc2 = [ -0.003;
        0.0029 ];
Cc = [ -0.32 1.0];
Dc1 = [  -0.00048    0.32];
Dc2 = [ 0.00048 ];

% Closed-loop system (p19-20 1.42-1.44)
Z = [eye(size(Dc1*Dp)) - Dc1*Dp];
Zinv = inv(Z);

A_cl = [Ap+Bp*Zinv*Dc1*Cp             Bp*Zinv*Cc;
        Bc1*(eye(size(Dp*Zinv*Dc1))+Dp*Zinv*Dc1)*Cp   Ac+Bc1*Dp*Zinv*Cc];

B_cl = [Bp*Zinv*Dc2;
        Bc2+Bc1*Dp*Zinv*Dc2];

C_cl = [(eye(size(Dp*Zinv*Dc1))+Dp*Zinv*Dc1)*Cp Dp*Zinv*Cc];

D_cl = [Dp*Zinv*Dc2];

sys_cl_1 = ss(A_cl, B_cl, C_cl, D_cl);
%sys_cl_2 = ss(plant,controller);%append(controller, plant);
%cl_sys = controller*plant
figure (1);
step(sys_cl_1);
%figure(2)
%step(sys_cl_2);
%step(sys_cl_3);


% Loop gain at input (p.20 1.49) 
A_Li = [Ap     zeros(2,2);
        Bc1*Cp Ac];
B_Li = [Bp; Bc1*Dp];
C_Li = -[Dc1*Cp Cc];
D_Li = -[Dc1*Dp];

sys_Li = ss(A_Li,B_Li,C_Li,D_Li);
% a)
figure (2)
bode(sys_Li);
grid on;
% identify GM and PM
[Gm Pm Wgm Wpm] = margin(sys_Li);
Gm = 20*log10(Gm)
Pm
Wgm
Wpm


% b)
figure (3)
nyquist(sys_Li);
grid on;
% identify GM and PM

% c) & d)
figure(4)
sigma(sys_Li, [],2);
retDiff = sigma(sys_Li, [],2);
grid on;

notdB = 10^(-5/20)

min(retDiff)

figure(5)
sigma(sys_Li, [],3);
stabRob = sigma(sys_Li, [],3);
grid on;

min(stabRob)

% e)
% SV Gain and Phase Margin (p.119 5.61-5.63)
a_sig = min(retDiff);
b_sig = min(stabRob);

GM_retDiff = [mag2db(1/(1+a_sig)) mag2db(1/(1-a_sig))]
GM_stabRob = [mag2db((1-b_sig))   mag2db((1+b_sig))]

PM_retDiff = [radtodeg(2*asin(a_sig/2)) radtodeg(-2*asin(a_sig/2))]
PM_stabRob = [radtodeg(2*asin(b_sig/2)) radtodeg(-2*asin(b_sig/2))]


% widest range is make the margins.

% Add actuator uncertainty

tau = 0.05;
nextTau = tau + 0.001;
[Ad, Bd, Cd, Dd] = tf2ss([-tau 0],[tau 1]);
del_sys = ss(Ad,Bd,Cd,Dd);
max_sig_del = 0;

w = logspace(0,3,500);
isMaxTauFound = 0;

stabRob_sv = sigma(sys_Li, w,3);
del_sys_sv = sigma(del_sys,w);

while (isMaxTauFound == 0)
    
    [Ad, Bd, Cd, Dd] = tf2ss([-nextTau 0],[nextTau 1]);
    del_sys = ss(Ad,Bd,Cd,Dd);
    stabRob_sv = sigma(sys_Li, w,3);
    del_sys_sv = sigma(del_sys,w);
    
    for(i=1:numel(w))

        if(stabRob_sv(i) < (del_sys_sv(i)))
            isMaxTauFound = 1;
            break
        end
    end
    
    if (isMaxTauFound == 0)
        tau = nextTau;
        nextTau = tau + 0.0001;
    else
        [Ad, Bd, Cd, Dd] = tf2ss([-nextTau 0],[nextTau 1]);
        del_sys = ss(Ad,Bd,Cd,Dd);
    end
end

tau
figure(5)
sigma(sys_Li, w,3);
grid on
hold on
sigma(del_sys)

%% Discussion
% Classic stability margins were computed to be:
% GM -12.1958 and PM = 81.7316 which would indicate a robust system
% SV GM: 4.8321 and SV PM: 43.6926. The singular value margins show that
% the margins are considerably smaller than those indicated by the
% classical values.

% A multiplicative error model for the first order actuator was derived:
% The delta-M model was: delta = -1/(s + 1/tau)

% The model was used to determine the specification of the time constant
% tau.

% The script above will iterate over the delta-M modeled uncertainties for
% the first order actuator varying the time constant tau. When the criteria
% for Robustness (as defined by the Small Gain Theorem) is met, i.e. when 
% the magnitud of delta is greater than the stability robustness, then the
% maximal value of tau will have been found. In this case the value found
% is tau=0.1271


