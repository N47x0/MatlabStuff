%% ESE 547 Homework 1
%Problem 1
A = diag([-1, -2, -3]);
A^2;
B = [3;-6;3];
C = [1,1,1];

S = ss(A,B,C,0);
cb1 = ctrb(S)

A2 = [0,1,0;0,0,1;-6,-11,-6];
B2 = [0;0;6];
C2 = [1,0,0];

S2 = ss(A2,B2,C2,0);

cb2 = ctrb(S2)

cb2Inv = inv(cb2)

T = cb1*cb2Inv
Tinv = inv(T)

z = Tinv*A*T
%%Problem2

A = [-1,1,0,0,0,0,0;
    0,-1,1,0,0,0,0;
    0,0,-1,0,0,0,0;
    0,0,0,-2,1,0,0;
    0,0,0,0,-2,0,0;
    0,0,0,0,0,-3,0;
    0,0,0,0,0,0,-4;]

t = sym('t');
eAt = expm(A*t)
