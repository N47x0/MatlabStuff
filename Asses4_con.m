function [g, h, grad_g, grad_h] = Asses4_con(x)
%  in-class example from AAE 550 Slide 11, Class 17
%  the format used here is compatible with fmincon
%  non-linear constraint functions 
%  
% last modified 06 Sep 2015 - Prof. Crossley

% inequality constraints
g(1) = 1 - x(1) * x(2)^2 / (27e6); 
g(2) = 1-x(1)^2*x(2)/(47e6);
g(3) = -2*x(1) + x(2);
g(4) = -x(1);
g(5) = -x(2);

% equality constraints - none in this problem
h = [];

% compute gradients
if nargout > 2   % called with 4 outputs
    % Matlab naming convention uses columns of grad_g for each gradient
    % vector.  Here, grad_g(1,1) is dg(1)/dx(1); grad_g(2,1) is
    % dg(1)/dx(2); grad_g(1,2) is dg(2)/dx(1); grad_g(2,2) is dg(2)/dx(2)
   grad_g = [-x(2)^2 / (27e6),    -2*x(1)*x(2)/(47e6), -2, -1,  0;  % gradients of the inequalities; each
             -2*x(2)*x(1)/(27e6), -x(1)^2 / (47e6),     1,  0, -1];        % column is one gradient vector
   grad_h = [];    % no equality constraints
end