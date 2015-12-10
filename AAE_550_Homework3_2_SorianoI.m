%% AAE_550_Homework3_2_SorianoI

clear all
clc

% Data
L2 = 1.2 %m
L1 = L2/sind(45);
L3 = L1;

% Rows: Truss, Col: Parameter(Material, x-sec)
% ex: for truss 1
% x(1,1): Material Choice
% x(1,2): Truss x-sec Area

vlb = [1 0.001;
       1 0.001;
       1 0.001];	%Lower bound of each gene - all variables
   
   % GA550 requires that the vlb be a 1xN vector, so we flatten.
   vlb = [vlb(1,:) vlb(2,:) vlb(3,:)];
   
vub = [4 .1;
       4 .1;
       4 .1];	%Upper bound of each gene - all variables
   
   % GA550 requires that the vub be a 1xN vector, so we flatten.
   vub = [vub(1,:) vub(2,:) vub(3,:)];
   
bits =[2 20;
       2 20;
       2 20];	%number of bits describing each gene - all variables
   
   % GA550 requires that the vub be a 1xN vector, so we flatten.
   bits = [bits(1,:) bits(2,:) bits(3,:)];

l = sum(bits);
N_pop = 4*l;
options = zeros(1,14);
options(1) = 2;
options(2) = 0.9;
options(11) = N_pop;
options(12) = .5;
options(13) = (l+1)/(2*N_pop*l);
options(14) = 200;
options = [];
options = goptions(options);

[x,fbest,stats,nfit,fgen,lgen,lfit]= GA550('homework3fun' ...
                                            ,[ ],options,vlb,vub,bits);
                                        
x
fbest