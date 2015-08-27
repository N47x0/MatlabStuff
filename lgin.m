function [A_li, B_li, C_li, D_li] = lgin(Ap, Bp, Cp, Dp, Ac, Bc1, Cc, Dc1)

% Loop gain at input (p.20 1.49) K.Wise & E. Lavretsky 
A_li = [Ap     zeros(size(Ap,1),size(Ac,2));
        Bc1*Cp Ac];
B_li = [Bp; Bc1*Dp];

% Negative to cancel out negative feedback
C_li = -[Dc1*Cp Cc];
D_li = -[Dc1*Dp];