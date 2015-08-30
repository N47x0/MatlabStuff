% Hw 9 Optimal Control.
% Problem 4. Missle Autopilot design
% Ignacio Soriano

% Problem parameters
Za = -1.3046;
Zd = -0.2142;
Ma = 47.7109;
Md = -104.8346;
V  = 886.78;
% State Space Realization
A = [Za 1; Ma 0];
B = [Zd; Md];
C = [Za*V 0]; %C = [1 0];
D = [Zd*V];

% Check Controllable system
Pc = [B A*B];
if rank(Pc) ~= rank(A)
    disp('The plant is not controlable');   
else
    % Form Wiggle system for a constant input.
    A_w = [0 C;
           0 A(1,:);
           0 A(2,:)];
    B_w = [D; B];
    
    if (rank([B_w A_w*B_w]) ~= rank(A_w))
        disp('The wiggle system is not controllable');
    else
        
       % Select control penalty matrices.
        Q = 0.*A_w;%[0.25 0 0; 0 0 0; 0 0 0];
        R = 1;
        xeig=[];
        qq = logspace(-2,3,100);
        w = logspace(-2,3,100);
        t = linspace(0,1,100);
        
        wn = 11;    %Hz for the actuator natural freq.
        ze = 0.707; %Damping ratio for second order actuator model.
        
        % Forming Plant Model for Analysis (w/ actuator)
        Ap = [A             B    zeros(2,1);
              zeros(1,3)            1;
              zeros(1,2) -wn*wn -2*ze*wn];
        Bp = [0;0;0;wn*wn];
        Cp = [C D 0;
              eye(4)];
        Dp = [zeros(size(Cp,1),1)];
        
         % Form Common Controller (Static Part)
        Ac = 0;
        Bc1 = [1 zeros(1,4)];
        Bc2 = -[1];
        Dc2 = 0;
            
        rtd = 180/pi;
        
        
        
        for i = 1:prod(size(qq));
            
            % Iterate LQR gains.
            Q(1,1) = qq(i);
            [K_w, S_w, E_w] = lqr(A_w, B_w, Q, R);
            
            % Feed LQR gains to common controller.
            Cc  = -[K_w(1)];
            Dc1 = -[0 K_w(2) K_w(3) 0 0];
            
            % Form new closed loop system.
            [A_cl, B_cl, C_cl, D_cl] = cccl(Ap, Bp, Cp, Dp, Ac, Bc1, Bc2, Cc, Dc1, Dc2);

            xx = eig(A_cl);
            xeig = [xeig;xx];
            
            % Form Loop gain at the input
            [A_li, B_li, C_li, D_li] = lgin(Ap,Bp,Cp,Dp,Ac,Bc1,Cc,Dc1);
            L = ss(A_li, B_li, C_li, D_li);
            
            % Obtain margins and crossover freq.
            %sigma(L,w);
            mag = sigma(L, w);
            %sigma(L, w, 2);
            retDiff = sigma(L, w, 2);
            %sigma(L, w, 3);
            stabRob = sigma(L, w, 3);  
            
            % Generate Analysis metrics
            minStabRob = min(abs(stabRob));
            minRetDiff = min(abs(retDiff));
            mag_dB = 20.*log10(mag)';
            wc = crosst(mag_dB, w);
            wiggle_sys = ss(A_cl, B_cl, C_cl, D_cl);
            %step(wiggle_sys, t)
            y = step(wiggle_sys, t);
            az = y(:,1);
            aze = abs(ones(size(az))-az);
            tau_r = 0;
            tau_s = 0;
            fv = aze(prod(size(aze)));
            e_n = aze - fv*ones(size(aze)) - 0.36*ones(size(aze));
            e_n1= abs(e_n)+e_n;
            tau_r = crosst(e_n1,t);
            e_n = aze - fv*ones(size(aze)) - 0.05*ones(size(aze));
            e_n1 = abs(e_n) + e_n;
            tau_s = crosst(e_n1,t);
            azmin = (abs(min(az)))*100;
            azmax = (abs(max(az))-1)*100;
            dmax = rtd*max(abs(y(:,4)))*32.174;
            ddmax = rtd*max(abs(y(:,5)))*32.174;
            metric=[ qq(i) minRetDiff minStabRob wc tau_r tau_s azmin azmax dmax ddmax];
            data(i,:) = metric;
            
            figure(1)
            plot(real(xeig),imag(xeig), '*')
            
            figure(2)
            plot(wc,tau_r, 'r*')
            hold on
            plot(wc,tau_s, 'o')
%             
%             figure(3)
            %plot(
            
        end
        
        
       
    end
    
end
