
function A = hw1almSUMT(x,r_p,lambda)
% This function is the pseudo-objective function using the ALM.
% In this function, r_p and lambda are parameters, and x are the 
% variables.
% Prof. Crossley 24 Oct 2009

% compute values of the objective function and constraints at the current
% value of x
f = hw1funSUMT(x);
g = hw1ConSUMT(x);

A = f;

ncon = length(g);
for j = 1:ncon
   % Fletcher's substitution
   psi(j) = max(g(j), lambda(j)/(2*r_p)); 
   
   % Augmented Lagrange
   A = lambda(j) * psi(j) + r_p*psi(j)^2;
end
