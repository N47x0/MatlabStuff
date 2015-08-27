% Prob 1.

%*************************************************************************
% Plant Model
%*************************************************************************
% State Names 
%  -----------
%  AZ fps2         
%  q rps           
%  Dele deg        
%  Dele dot dps    
%  Input Names
%  -----------
%  Dele cmd deg    
Ap = [  -0.576007  -3255.07    4.88557 9.25796;
        -0.0410072  -0.488642 -2.03681 0;
         0           0         0       1;
         0           0       -8882.64 -133.266];
Bp = [ 0; 0; 0; 8882.64];
Cp = [  1    0    0    0;
        0    1    0    0];
Dp = 0.*Cp*Bp;


%*******************************************************
% Static Output Feedback With New Form To Test Prior To Substituting 
% The Big Plant Model
%*******************************************************  
% Close the loop to test the model
% Plant form  xdot = Apx + Bpu; y = Cpx +Dpu
% Controller xcdot = Acxc + Bc1y + Bc2r
%                      u = Ccxc + Dc1y + Dc2r
Ac = [ 0 ];
Bc1 = [-1   0];
Bc2 = [ 1 ];
Cc = [  0.0107349];
Dc1 = [  -0.0411729    11.4003];
Dc2 = [ 0 ];



% a) Plot a Bode Plot and identify on the plot the gain and phase margins.
% loop gain crossover frequency and phase crossover frequencies.

