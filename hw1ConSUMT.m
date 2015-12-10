function g = hw1ConSUMT(x)

d_o = x(1);
t = x(2);

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
M = W*(H+0.5*h)+del*P; % N m
f_b = M*d_o/(2*I); % m
f_a = P/xsecA; % m

% g(1) = P - sigma_a*pi*t*d_o;
% g(2) = (P*d_o*del + d_o*W*(H+0.5*h) - (sigma_b*2*I)) * 2*E*I/H ;
% g(3) = 2*E*I/H *(del - 0.3);
% g(4) = d_o - 80*t;
g(1) = P/(sigma_a*pi*t*(d_o-t)) - 1;
g(2) = M*d_o/(sigma_b*2*I) - 1;
g(3) = del/0.3 - 1;
g(4) = d_o/(80*t) - 1;
g(5) = 0.55 - (d_o - t);
g(6) = (d_o - t) - 2.8;
g(7) = 0.05 - t;
g(8) = t - 0.35;
g(9) = d_o - 3.15;
end

% 
% g(2) = P*d_o*( W*H/6*(4*H+3*h)+(0.5*W*h) )*(H*h) ... 
%        +( 2*E*I/H *d_o*W*(H+0.5*h) ) ...
%        -(sigma_b*4*I^2*E/H);