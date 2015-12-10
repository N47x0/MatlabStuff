function [V,gradV] = potEnergyDispGrad(x,K,P)

V = 0.5*x'*K*x - P'*x;

if nargout > 1
    gradV = [0.5*(2*x(1)*K(1,1)+x(2)*K(1,2)+x(2)*K(2,1))-P(1); ...
            0.5*(2*x(2)*K(2,2)+x(1)*K(1,2)+x(1)*K(2,1))-P(2);] ;   
end