% This file calls fminunc to minimize the constrained example from AAE 550
% class notes  - see slide 21, Class 02.  This will use the exterior
% penalty function; to use other methods, you will need to change the
% pseudo-objective function file and possibly change the penalty multiplier
% update strategy.  Also, note that there are no constraint scaling
% parameters here.
%
% Prof. Crossley 24 Sep 2009
clear all
format long    % use format long to see differences near convergence

% x0 = [2; 0.07];   % initial design
% p = 0;         % initial value of minimization counter 
% r_p = 1.0;     % initial value of penalty multiplier 
% 
% % compute function value at x0, initialize convergence criteria
% f = hw1funSUMT(x0);
% f_last = 2 * f;   % ensure that first loop does not trigger convergence
% % set optimization options - use default BFGS with numerical gradients
% % provide display each iteration
% options = optimset('LargeScale', 'off', 'Display', 'iter');  
% 
% % begin sequential minimizations  - note tolerances chosen here
% % absolute tolerance for change in objective function, absolute tolerance
% % for constraints
% while ((abs((f-f_last)/f_last) >= 1e-3) || (max(g) >= 1e-5))
%     f_last = f;  % store last objective function value
%     p            % display current minimization counter
%     r_p          % display current penalty multiplier
%     % call fminunc - use "phi" pseudo-objective function, note that r_p is
%     % passed as a "parameter", no semi-colon to display results
%     [xstar,phistar,exitflag,output] = fminunc(@hw1ExtLinPhiSUMT,x0,options,r_p)
%     % compute objective and constraints at current xstar
%     f = hw1funSUMT(xstar);
%     g = hw1ConSUMT(xstar);
%     p = p + 1;     % increment minimization counter
%     r_p = r_p * 5; % increase penalty multiplier
%     x0 = xstar;    % use current xstar as next x0
% end
% % display function and constraint values at last solution
% f = hw1funSUMT(xstar)
% g = hw1ConSUMT(xstar)
% xstar
% format short

%% Restart for ALM
x0 = [2; 0.07];   % initial design
p = 0;         % initial value of minimization counter 
r_p = 1.0;     % initial value of penalty multiplier 
lambda = [0;0;0;0;0;0;0;0;0];     % initial Lagrange multipliers

options = optimset('LargeScale', 'off', 'Display', 'iter'); 
% compute function value at x0, initialize convergence criteria
f = hw1funSUMT(x0);
f_last = 2 * f;   % ensure that first loop does not trigger convergence
% set optimization options - use default BFGS with numerical gradients
% provide display each iteration
% begin sequential minimizations  - note tolerances chosen here
% absolute tolerance for change in objective function, absolute tolerance
% for constraints.
while ((abs((f-f_last)/f_last) >= 1e-3) || (max(g) >= 1e-5))
    f_last = f;  % store last objective function value
    p            % display current minimization counter
    lambda       % display current Lagrange multiplier values
    r_p          % display current penalty multiplier
    % call fminunc - use "ALM" pseudo-objective function, note that r_p and
    % lambda are passed as parameters, no semi-colon to display results
    [xstar,phistar] = fminunc(@hw1almSUMT,x0,options,r_p,lambda)
    % compute objective and constraints at current xstar
    f = hw1funSUMT(xstar);
    g = hw1ConSUMT(xstar);
    % update lagrange multipliers
    lambda(1) = lambda(1) + 2 * r_p * max(g(1), -lambda(1)/(2*r_p));
    lambda(2) = lambda(2) + 2 * r_p * max(g(2), -lambda(2)/(2*r_p));
    p = p + 1;     % increment minimization counter
    r_p = r_p * 5; % increase penalty multiplier
    x0 = xstar;    % use current xstar as next x0
end
% display function and constraint values at last solution
f = hw1funSUMT(xstar);
g = hw1ConSUMT(xstar);
format short

