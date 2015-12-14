%% AAE_550_Hw1_Q2_SorianoI
clear all
format long

% Problem 1 set-up
% Given data and equations:

d_0 = 0; % m unknown
t = 0; % m unknown

% Independent - constant
h = 15; % m
H = 40; % m
D = 10; % m
w = 700; % N/m^2
gammaH20 = 10000; % N/m^3
gammaSteel = 80000; % N/m^3
E = 210000000000; % Pa or N/m^2
sigma_b = 165000000; % Pa or N/m^2 
V = 1.2*pi*D^2*h; % m^3
A_s = 1.23*pi*D^2; % m^2
A_p = 2*D*h/3; % m^2
t_t = 0.015; % m
P = V*gammaH20 + A_s*t_t*gammaSteel; % N
W = w*A_p; % N
 
% Dependent - variable
I = pi/64 * [d_o^4 - (d_o-2*t)^4]; % Moment of inertia m^4
xsecA = pi*t*(d_o - t); % m^2
r = sqrt(I/xsecA); % m
sigma_a = 12*pi^2*E/(92*(H/r)^2); % Pa or N/m^2
del_1 = W*H^2*(4*H + 3*h)/(12*E*I); % m
del_2 = H*(0.5*W*h)*(H+h)/(2*E*I); % m
del = del_1 + del_2; % m
M = W*(H+0.5h)+del*P; % N m
f_b = M*d_o/(2*I); % m
f_a = P/xsecA; % m






























