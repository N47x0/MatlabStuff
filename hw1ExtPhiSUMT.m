function phi = hw1ExtPhiSUMT(x,r_p)
% This function is the pseudo-objective function using the exterior penalty.
% In this function, r_p is a "parameter", x are the variables.  This
% example does not include constraint scaling parameters, cj.
% Prof. Crossley 24 Sep 2009

% compute values of the objective function and constraints at the current
% value of x
f = hw1funSUMT(x);
g = hw1ConSUMT(x);

% exterior penalty function
ncon = length(g);   % number of constraints
P = 0;              % intialize P value to zero
for j = 1:ncon
    P = P + max(0,g(j))^2;  % note: no c_j scaling parameters
end
phi = f + r_p * P;
