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
Ap = [  -1.3046  1.0    -0.21420 0;
        47.711  0       -104.83  0;
         0           0         0       1;
         0           0       -12769 -135.6];
Bp = [ 0; 0; 0; 12769.0];
Cp = [  -1156.9    0    -189.95    0;
        0    1    0    0];
Dp = [0;0];


%*******************************************************
% Static Output Feedback With New Form To Test Prior To Substituting 
% The Big Plant Model
%*******************************************************  
% Close the loop to test the model
% Plant form  xdot = Apx + Bpu; y = Cpx +Dpu
% Controller xcdot = Acxc + Bc1y + Bc2r
%                      u = Ccxc + Dc1y + Dc2r
Ac = [ 0 0; -1.92 0];
Bc1 = [0.003   0; -0.0029 1.92];
Bc2 = [ -0.003; 0.0029 ];
Cc = [ -0.32 1.0];
Dc1 = [  -0.00048    0.32];
Dc2 = [ 0.00048 ];

% Closed-loop system (p19-20 1.42-1.44)
Z = [eye(1) - Dc1*Dp];
Zinv = inv(Z);

A_cl = (Ap + Bp*Zinv*Dc1*Cp)             Bp*Zinv*Cc;
        Bc5r = ss(Ac, [Bc1 Bc2], Cc, [Dc1 Dc2]);

sys_cl_1 = ss(A_cl, B_cl, C_cl, D_cl);
%sys_cl_2 = ss(plant,controller);%append(controller, plant);
%cl_sys = controller*plant
figure (1)
step(sys_cl_1);
%figure(2)
%step(sys_cl_2);
%step(sys_cl_3);


% Loop gain at input (p.20 1.49) 
A_Li = [Ap     zeros(4,2);
        Bc1*Cp Ac];
B_Li = [Bp; Bc1*Dp];
C_Li = -[Dc1*Cp Cc];
D_Li = -[Dc1*Dp];

sys_Li = ss(A_Li,B_Li,C_Li,D_Li);
% a)
figure (2)
bode(sys_Li);
% identify GM and PM

% b)
figure (3)
nyquist(sys_Li);
% identify GM and PM

% c) & d)

retDiff = sigma(sys_Li, [],2);
stabRob = sigma(sys_Li, [],3);

% e)
% SV Gain and Phase Margin (p.119 5.61-5.63)
a_sig = min(retDiff);
b_sig = min(stabRob);

GM_retDiff = [mag2db(1/(1+a_sig)) mag2db(1/(1-a_sig))];
GM_stabRob = [mag2db(1/(1+b_sig)) mag2db(1/(1-b_sig))];

PM_retDiff = [2*asin(a_sig/2) -2*asin(a_sig/2)];
PM_stabRob = [2*asin(b_sig/2) -2*asin(b_sig/2)];

% widest range is make the margins.



