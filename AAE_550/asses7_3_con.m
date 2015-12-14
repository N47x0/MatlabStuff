function [g, h, grad_g, grad_h] = asses7_3_con(x, sig_coef)
%  in-class example from AAE 550 Slide 11, Class 17
%  the format used here is compatible with fmincon
%  non-linear constraint functions 
%  
% last modified 06 Sep 2015 - Prof. Crossley

% inequality constraints
sig= [];
sig_y = 20000;
for i=1:3
    sig = [sig; sig_coef(i,1) + sig_coef(i,2)*x(1) + sig_coef(i,3)*x(2)...
              + sig_coef(i,4)*x(3) + sig_coef(i,5)*x(1)^2 ...
              + sig_coef(i,6)*x(1)*x(2) + sig_coef(i,7)*x(1)*x(3) ...
              + sig_coef(i,8)*x(2)^2 + sig_coef(i,9)*x(2)*x(3) ...
              + sig_coef(i,10)*x(3)^2];
end

g(1) = sig(1)/sig_y -1; 
g(2) = sig(2)/sig_y -1;
g(3) = sig(3)/sig_y -1;

% equality constraints - none in this problem
h = [];

% compute gradients
if nargout > 2   % called with 4 outputs
    % Matlab naming convention uses columns of grad_g for each gradient
    % vector.  Here, grad_g(1,1) is dg(1)/dx(1); grad_g(2,1) is
    % dg(1)/dx(2); grad_g(1,2) is dg(2)/dx(1); grad_g(2,2) is dg(2)/dx(2)
   %grad_g = [-2 * x(2)/ 3, 2 * x(1);  % gradients of the inequalities; each
   %    -2 * x(1) / 3, -4 / 3];        % column is one gradient vector
   %grad_h = [];    % no equality constraints
end