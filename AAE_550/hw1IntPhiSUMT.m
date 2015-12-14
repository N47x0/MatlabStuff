function phi = hw1IntPhiSUMT(x,r_p)
% compute values of the objective function and constraints at the current
% value of x
f = hw1funSUMT(x);
g = hw1ConSUMT(x);

% exterior penalty function
ncon = length(g);   % number of constraints
P = 0;              % intialize P value to zero
for j = 1:ncon
    
    P = P + -1/g(j);  % note: no c_j scaling parameters
end
phi = f + r_p * P;


