% use fmincon to solve the in-class example problem in class 23
% Fall 2015
% last modified 06 Oct 2015 - Prof. Crossley
% NOTES:  This method uses the default numerical gradient option in
% fmincon, but both example_fun and example_con can provide user-defined
% gradients.  To do this, change the options in optimset.
%
clear all
% no linear inequality constraints
A = [];
b = [];
% no linear equality constraints
Aeq = [];
beq = [];
% lower bounds (no explicit bounds in example)
lb = [ ];
% upper bounds (no explicit bounds in example)
ub = [];
% set options for medium scale algorithm with active set (SQP as described
% in class; these options do not include user-defined gradients
options = optimoptions('fmincon','Algorithm','sqp', 'Display',...         'iter');
% initial guess  - note that this is infeasible
x0 = [3; 3];
[x,fval,exitflag,output] = fmincon('example_fun',x0,A,b,Aeq,beq,lb,ub, ...
    'example_con',options)

% NOTES:  since this is a direct constrained minimization method, you
% should try several initial design points to be sure that you have not
% located a local minimum.