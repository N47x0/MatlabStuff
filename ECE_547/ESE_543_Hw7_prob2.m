
% Prob 2
%constants
Ka = -0.0015;
Kq = -0.32;
az = 2.0;
aq = 6.0;

Za = -1.3046;
Zd = -0.2142;
Ma = 47.7109;
Md = -104.8346;
V  = 886.78;

wn = 150;
z  = 0.6;

% Controller realization
Ac  = [0 0; Kq*aq 0];
Bc1 = [-Ka*az 0; -Ka*Kq*aq -Kq*aq];
Bc2 = [Ka*az; Ka*Kq*aq];
Cc  = [Kq 1];
Dc1 = [-Ka*Kq -Kq];
Dc2 = [Ka*Kq];

% Controller TF
K_az = tf([Ka Ka*az], [1 0]);
K_q  = tf([Kq Kq*aq], [1 0]);
K_sys = [K_az*K_q K_q];

% Plant Realization
Ap = [Za 1; Ma 0];
Bp = [Zd; Md];
Cp = [V*Za 0; 0 1];
Dp = [V*Zd; 0];
P_sys = ss(Ap,Bp,Cp,Dp);

% LoopGain at input realization.
Lin_sys = (K_sys*P_sys);

%Loop Gain at Input
A_lu = [Ap zeros(2,2); Bc1 Ac];
B_lu = [Bp; Bc1*Dp];
C_lu = [Dc1*Cp Cc];
D_lu = [Dc1*Dp];

Lu_sys = ss(A_lu, B_lu, C_lu, D_lu);

% Closed Loop Realization
Z = eye(1)-Dc1*Dp;

A_cl = [Ap+Bp*inv(Z)*Dc1*Cp Bp*inv(Z)*Cc; Bc1*(eye(2)+Dp*inv(Z)*Dc1)*Cp Ac+Bc1*Dp*inv(Z)*Cc];
B_cl = [Bp*inv(Z)*Dc2; Bc2+Bc1*Dp*inv(Z)*Dc2];
C_cl = [(eye(2)+Dp*inv(Z)*Dc1)*Cp Dp*inv(Z)*Cc];
D_cl = [Dp*inv(Z)*Dc2];

CL_sys = ss(A_cl, B_cl, C_cl, D_cl);
step(CL_sys)
S = stepinfo(CL_sys);

% Second Order Actuator
% A_act = [0 1; -(wn^2) -2*z*wn];
% B_act = [0; wn^2];
% C_act = [Zd 0; 0 0];
% D_act = 0;
Act_2nd = tf([wn^2],[1 2*z*wn wn^2]);

figure(1);
nyquist(Lin_sys)
grid on;
axis ([-3 3 -3 3])
figure(2)
bode(Lin_sys)
grid on
figure(3)
sigma(eye(2) + Lin_sys)
grid on


CL_sys = ss(A_cl, B_cl, C_cl, D_cl);
figure(4)
step(CL_sys)
grid on
S = stepinfo(CL_sys);

R_Dif = eye(2) + Lin_sys;
RobustMat = eye(2) + inv(Lin_sys);

w1 = logspace(0,5,500);
s_min = 10000000;
for count=1:length(w1) 
    temp = min(svds((w1(count))));
    if (temp < s_min)
        s_min = temp;    
    end
end

figure(5);

sigma(eye(2)+Lu_sys)
grid on
min(sigma(eye(2)+Lu_sys))
min(sigma(eye(2)+inv(Lu_sys)))

[Cm, Dm, Mm] = loopmargin(Lin_sys);

% Prob 3
% adding second order actuator.
figure(6)
Lin_2nd = (K_sys*Act_2nd*P_sys);
nyquist(Lin_2nd)
grid on;
axis ([-3 3 -3 3])
figure(7)
bode(Lin_2nd)
grid on
figure(8)
sigma(eye(2) + Lin_2nd)
grid on






