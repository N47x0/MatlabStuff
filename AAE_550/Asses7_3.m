clear all
clc

data = load('ques29v3.dat');

A1 = data(:,1);
A2 = data(:,2);
A3 = data(:,3);
mass = data(:,4);
X = [];

sig_y = 20000; %psi

for i=1:numel(data(:,1))
   X = [X; 1 A1(i) A2(i) A3(i)...
             A1(i)^2 A1(i)*A2(i) A1(i)*A3(i)...
             A2(i)^2 A2(i)*A3(i) A3(i)^3];  
end

a = X\mass



sig_coef = X\data(:,5);
sig_coef = [sig_coef X\data(:,6)];
sig_coef = [sig_coef X\data(:,7)];

constr = @(x)asses7_3_con(x,sig_coef'); 

% use fmincon to solve the in-class example problem in class 23
% Fall 2015
% last modified 06 Oct 2015 - Prof. Crossley
% NOTES:  This method uses the default numerical gradient option in
% fmincon, but both example_fun and example_con can provide user-defined
% gradients.  To do this, change the options in optimset.
%

% no linear inequality constraints
A = [];
b = [];
% no linear equality constraints
Aeq = [];
beq = [];
% lower bounds (no explicit bounds in example)
lb = [ 0.1 0.1 0.1 ];
% upper bounds (no explicit bounds in example)
ub = [5 5 5];
% set options for medium scale algorithm with active set (SQP as described
% in class; these options do not include user-defined gradients
options = optimoptions('fmincon','Algorithm','sqp', 'Display','iter');
% initial guess  - note that this is infeasible
x0 = [.5; .5; .5];
[x,fval,exitflag,output] = fmincon('asses7_3_fun',x0,A,b,Aeq,beq,lb,ub, ...
    constr,options)

% NOTES:  since this is a direct constrained minimization method, you
% should try several initial design points to be sure that you have not
% located a local minimum.