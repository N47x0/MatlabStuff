function [A_cl, B_cl, C_cl, D_cl] = cccl(Ap, Bp, Cp, Dp, Ac, Bc1, Bc2, Cc, Dc1, Dc2)

% Closed-loop system (p19-20 1.42-1.44) K. Wise & E. Lavretsky
Z = [eye(size(Dc1*Dp)) - Dc1*Dp];
Zinv = inv(Z);

res_A = [Ap+Bp*Zinv*Dc1*Cp             Bp*Zinv*Cc;
        Bc1*(eye(size(Dp*Zinv*Dc1))+Dp*Zinv*Dc1)*Cp   Ac+Bc1*Dp*Zinv*Cc];

res_B = [Bp*Zinv*Dc2;
        Bc2+Bc1*Dp*Zinv*Dc2];

res_C = [(eye(size(Dp*Zinv*Dc1))+Dp*Zinv*Dc1)*Cp Dp*Zinv*Cc];

res_D = [Dp*Zinv*Dc2];

A_cl = res_A;
B_cl = res_B;
C_cl = res_C;
D_cl = res_D;