
% Simplex method

close all;
clear all;
clc;

options = optimset('Display','iter');

x0 = [1; 1];
x0 = [1.0635; 1.1073];
x0 = [10;5];
x0 = [9.9020; 5.2184];
x0 = [10;10];
x0 = [9.8466;9.5751];
%[x,fval,exitflag,output] = fminsearch('Langermann_NM',x0,options)

%x

% Simulated Anneiling

bounds = [0 10;
          0 10];	% upper and lower bounds for each of the two variables

X0 = [10;5];	% initial design NOTE: this is a column vector
%X0 = [1;1];
options = zeros(1,9);		% set up options array for non-default inputs

options(1) = 100;			% initial temperature (default = 50)
options(6) = 0.9;		% cooling rate (default = 0.5)

%[xstar,fstar,count,accept,oob]=SA_550('Langermann_SA',bounds,X0,options);
%xstar
%fstar
%count

% Genetic Algorithms

vlb = [0 0];	%Lower bound of each gene - all variables
vub = [10 10];	%Upper bound of each gene - all variables
bits =[30 30];	%number of bits describing each gene - all variables

l = sum(bits);
N_pop = 4*l;
options = zeros(1,14);
options(1) = 2;
options(2) = .9;
options(11) = N_pop;
options(12) = .5;
options(13) = (l+1)/(2*N_pop*l);
options(14) = 200;
%options = [];
options = goptions(options);

[x,fbest,stats,nfit,fgen,lgen,lfit]= GA550('LangermannGA',[ ],options,vlb,vub,bits);
x
fbest

