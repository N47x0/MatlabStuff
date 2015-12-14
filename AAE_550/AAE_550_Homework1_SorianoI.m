%% AAE 550 Homework 1
% Ignacio Soriano
clear all
format long

%% Problem 1
%
% Given Data
% Dimensions of truss structure:

theta1 = 41; % deg
theta3 = 15; % deg
totXlen = 5.3; % ft
totYlen = 3.3; % ft
baseL1L2 = 3.6; % ft

% Equations formed.

% Eq 1:
L1L3 = [cosd(theta1) sind(theta3);
        sind(theta1) cosd(theta3)];

totalL = [totYlen totXlen];
% Solve sys of two eq.
L = L1L3\totalL';
% Rename
L1 = L(1);
L3 = L(2);

% Eq 2:
theta2 = atand((baseL1L2 - L1*sind(theta1))/(totYlen-L3*sin(theta3)))

% Eq 3:
L2 = (totYlen - L3*sind(theta3))/cosd(theta2);

% Variable rename (vectorize)
L = [L1 L2 L3];
L = L.*12 % conversion from ft to inches
theta = [theta1 theta2 theta3];

% More given data
E = 16e6; % psi Young's Modulus of material

trussDiameters = [0.75 0.85 1]; % inches: Truss1 Truss2 Truss3 respectively
A = pi*(trussDiameters/2).^2 % Truss areas ft^2

p = 25000; % lbs Load on free end
phi = 80; % deg 
P = [p*cosd(phi); p*sind(phi)]; % Load Components in x,y coord.


% Stiffness Matrix
m1 = [sind(-theta(1));
      cosd(theta(1))];
m2 = [sind(theta(2))
      cosd(theta(2))];
m3 = [cosd(theta(3))
      sind(-theta(3))];
M = [m1 m2 m3];
K = [0 0; 0 0];

for i=1:3
    K = K + M(:,i)*(E*A(i)/L(i))*(M(:,i))'
end



disp('Part1 a')
xstar = [0.1; 0.1];   % initial design
options = optimset('LargeScale', 'off', 'GradObj', 'off', 'Display', 'iter');  % display each iteration
[xnum,fval,exitflag,output,grad] = fminunc(@potEnergyDisp,xstar,options, K, P)  

disp('Part1 b')
xstar = [0.1; 0.1];   % initial design
options = optimset('LargeScale', 'off', 'GradObj', 'on', 'Display', 'iter');          % display each iteration
[xnum,fval,exitflag,output,grad] = fminunc('potEnergyDispGrad',xstar,options, K, P)  

disp('Part2 a')
xstar = [0.1; 0.1];   % initial design
options = optimset('LargeScale', 'off', 'GradObj', 'on', 'Display', 'iter', 'HessUpdate', 'dfp');  % display each iteration
[xnum,fval,exitflag,output,grad] = fminunc('potEnergyDispGrad',xstar,options, K, P)  

disp('Part2 b')
xstar = [0.1; 0.1];   % initial design
options = optimset('LargeScale', 'off', 'GradObj', 'on', 'Display', 'iter', 'HessUpdate', 'steepdesc');  % display each iteration
[xnum,fval,exitflag,output,grad] = fminunc('potEnergyDispGrad',xstar,options, K, P)                         % lots of information 

disp('Part3 a')
xstar = [0.01; 0.15];   % initial design
options = optimset('LargeScale', 'on', 'GradObj', 'on', 'Display', 'iter', 'Hessian', 'on');  % display each iteration
[xnum,fval,exitflag,output,grad] = fminunc('potEnergyDispGradHess',xstar,options, K, P)        % lots of information 

u = K\P



