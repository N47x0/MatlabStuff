%% AAE_550 MDO Assessment 0

%% Question 1
disp('Question 1')
a = [7;1;3];
b = [8;8;3];
A = [6 8 9;
     5 6 4;
     4 6 8];
 
 % 1
 disp('1)')
 if (dot(a,b) == a.'*b)
     disp('dot(a,b) == a''*b')
 else
     disp('dot(a,b) ~= a''*b')
 end
 
 % 2
 disp('2)')
 if (dot(b,a) == b*a.')
     disp('dot(b,a) == b.''*a')
 else
     disp('dot(b,a) ~= b.''*a')
 end
 
 % 3
 disp('3)')
 
 a.'*b
 
 % 4
 disp('4)')
 c = b*a.'
 
 % 5
 disp('5)')
 B = (c)*A
 
 % 6
 disp('6)')
 B.'
 
%% Question 2
disp('Question 2')
A = [2 -2 0;
  5 -8 1;
  -3 3 2];

b = [10; -2; 15;];

% 1
disp('1)')
det(A)

% 2
disp('2)')
inv(A)

% 3
disp('3)')
linsolve(A,b)

% 4
disp('4)')
eig(A)
 
%% Question 3
disp('Question 3')

a = 5;
b = 3;

syms x y f(x,y) g(x,y)
f = cos(4*x^2 + y) + x - y^2 - 9*x*y

G = gradient(f, [x,y])
H = hessian(f, [x,y])

% 1
disp('1)')
G(1)

% 2
disp('2)')
g(x,y) = G(1)
res = [g(a,b)]
g(x,y) = G(2)
res = [res; g(a,b)]

% 3
disp('3)')

g(x,y) = H(1,1);
res = g(a,b)
e1 = [res]
g(x,y) = H(1,2);
res = g(a,b)
e1 = [e1 res]
g(x,y) = H(2,1);
res = g(a,b)
e2 = res
g(x,y) = H(2,2);
res = g(a,b)
e2 = [e2 res]

% 4
disp('4)')
E = eig([e1;e2])



