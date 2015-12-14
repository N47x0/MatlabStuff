%% AAE 550 Assesment 1
%% Question 4: Karush-Kuhn-Tucker Conditions

syms x y f(x,y) g(x,y) g1(x,y) g2(x,y)
f = 2*x^2 - y^2;
 
g1 = x^2 - y - 9;
g2 = -x + y + 3;

x_opt = [-2; -5];

g1_x = 2*x_opt(1)^2 + x_opt(2) - 9;
g2_x = 2*x_opt(2) + 3;



 g(x,y) = gradient(f, [x,y]);
 f_x = g(x_opt(1),x_opt(2));
 
 g(x,y) = gradient(g1, [x,y]);
 g1_x = g(x_opt(1),x_opt(2));
 
 g(x,y) = gradient(g2, [x,y]);
 g2_x = g(x_opt(1),x_opt(2));
 
 A = [g1_x(1) g2_x(1);g1_x(2) g2_x(2)];
 b = [-f_x(1);-f_x(2)];
 
 lambda = A\b;
 double(lambda)

 %% Question 5: Newton's Method
 syms f5(x) df5(x) ddf5(x)
 f5 = 15 - 5.25*x - sqrt(2)*x^2 + 2*x^4;
 
 df5 = diff(f5);
 ddf5 = diff(df5);
 xk = 7;
 for i=1:4
     xk1 = xk - subs(df5,x,xk)/subs(ddf5,x,xk);
     double(xk1);
     xk = xk1;
     
 end
 
 %% Question 6: Polynomial Approximation
 
syms f6(x)
f6 = 1.5*x^4 - 5*x^3 + 53*x^2 - 15.55*x;

x1 = 0;
x2 = -8;
x3 = -2;

x = [x1; x2; x3];
f_x = [];

for i=1:3
    f_x = [f_x subs(f6,x(i))];
end
double(f_x);

for i=1:4
    M = [1 x(1) x(1)^2;
         1 x(2) x(2)^2;
         1 x(3) x(3)^2];

    a = M\f_x';
    %disp(['x(',3+i,')']);
    x_new = -a(2)/(2*a(3));
    double(x_new);

    f_x_new = subs(f6,x_new);
    max_f = max(f_x);
    if (f_x_new < max_f)
        for i=1:numel(f_x)
            if (f_x(i) == max_f)
                f_x(i) = f_x_new;
                x(i) = x_new;
            end
        end
    end
    %disp(['f_x']);
    double(f_x);
    %disp(['x']);
    double(x);
end

%% Question 7: Golden Section
syms f7(x) x1(xL,xU) x2(xL,xU)

f7 = -2.5 - 4*x + pi*x^2;

tau = (3 - sqrt(5))/2;

x1 = xL*(1-tau) + tau*xU; % Closer to lower
x2 = xL*tau+(1-tau)*xU;   % Closer to upper

x_U = 1;
x_L = -3;

x_1 = subs(x1,[xL, xU], [x_L, x_U]);
x_2 = subs(x2,[xL, xU], [x_L, x_U]);

disp(['x1 ']);
double(x_1)
disp(['x2 ']);
double(x_2)

f7_x1 = subs(f7,x_1);
f7_x2 = subs(f7,x_2);

f7_x = [subs(f7,x_L) f7_x1 f7_x2 subs(f7,x_U)];
disp('f7_x')
double(f7_x)

for i=3:4
    disp(['x ',num2str(i)]);
    if (f7_x1 < f7_x2)
        x_U = x_2;
        x_2 = x_1;
        x_1 = subs(x1,[xL, xU], [x_L, x_U]);
        f7_x1 = subs(f7,x_1);
        double(f7_x1)
        double(x_1)
    else
        x_L = x_1;
        x_1 = x_2;
        x_2 = subs(x2,[xL, xU], [x_L, x_U]);
        f7_x2 = subs(f7,x_2);
        double(f7_x2)
        double(x_2)
    end
end
x = [x_L x_1 x_2 x_U];
f7_x = [subs(f7,x_L) f7_x1 f7_x2 subs(f7,x_U)];
disp('x')
double(x)
disp('f7_x')
double(f7_x)





