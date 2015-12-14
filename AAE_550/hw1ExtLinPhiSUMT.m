function phi = hw1ExtLinPhiSUMT(x,r_p)

% compute values of the objective function and constraints at the current
% value of x
f = hw1funSUMT(x);
g = hw1ConSUMT(x);

% exterior penalty function
ncon = length(g);   % number of constraints
P = 0;              % intialize P value to zero
eps = -0.1;
for j = 1:ncon
    if (g(j) <= eps)
        P = -1/g(j);
    else
        P = -((g(j)/eps)^2 -3*(g(j)/eps) + 3)/eps;
    end
    
end
phi = f + r_p * P;

