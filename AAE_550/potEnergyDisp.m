function V = potEnergyDisp(x, K, P)
    V = 0.5*x'*K*x - P'*x;
end