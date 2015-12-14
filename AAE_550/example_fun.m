function [f, grad_f] = example_fun(x)
%  in-class example from AAE 550 Slide 11, Class 17
%  the format used here is compatible with fmincon
%  non-linear objective function 
%  
% last modified 06 Sep 2015 - Prof. Crossley

f = x(1)^4 + x(2)^2 - x(1)^2 * x(2);    

if nargout > 1  % fun called with two output arguments
    % Matlab naming convention will use grad_f(1) as df/dx(1); grad_f(2) as
    % df/dx(2)
    grad_f = [4 * x(1)^3 - 2 * x(1) * x(2); 
        2 * x(2) - x(1)^2];      % Compute the gradient evaluated at x
end