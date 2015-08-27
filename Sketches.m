Za = -1.2100;
Zd = -0.1987;
Ma = 44.2506;
Md = -97.2313;

syms k1 kx1 kx2
[k1, kx1, kx2] = solve(-Za + Zd*kx2 == 18, (Md*kx2*(-Za+Zd*kx1))-(Zd*k1-(1+Zd*kx2)*(Ma + Md*kx1)) == 107, (1+Zd*kx2)*(Md*k1)-(Zd*k1)*(Md*kx2) == 210)

double(k1)
double(kx1)
double(kx2)

syms p1 p2 p3
[p1, p2, p3] = solve(2*p2-p1*p3 + 1 == 0, p1 + p3 - p1*p3 == 0, 2*p2 - p3*p3 == 0)

double(p1)
double(p2)
double(p3)