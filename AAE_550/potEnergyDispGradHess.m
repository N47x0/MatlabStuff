function [V,gradV, hessV] = potEnergyDispGradHess(x,K,P)

V = 0.5*x'*K*x - P'*x;

if nargout > 1
    gradV = [0.5*(2*x(1)*K(1,1)+x(2)*K(1,2)+x(2)*K(2,1))-P(1); ...
            0.5*(2*x(2)*K(2,2)+x(1)*K(1,2)+x(1)*K(2,1))-P(2)] ;   
        
    hessV = [K(1,1) + .5*(K(1,2)*K(2,1))  .5*(K(1,2)*K(2,1)); ...
             .5*(K(1,2)*K(2,1))        K(2,2) + .5*(K(1,2)*K(2,1))];
end