function f = hw1funSUMT(x)
% this function computes the objective function value for
% the simple constrained example in the AAE 550 class notes  - see slide 
% 21, Class 02
% Prof. Crossley 24 Sep 2009

% objective

d_o = x(1);
t   = x(2);

f = t*(d_o-t);

