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
C = [1 0];%C = [Za*V 0];

% Check Controllable system
Pc = [B A*B];
if rank(Pc) ~= rank(A)
    disp('The plant is not controlable');   
else
    % Form Wiggle system for a constant input.
    A_w = [0 C;
           0 A(1,:);
           0 A(2,:)];
    B_w = [0; B];
    
    if (rank([B_w A_w*B_w]) ~= rank(A_w))
        disp('The wiggle system is not controllable');
    else
        
       % Select control penalty matrices.
        Q = 0.*A_w;%[0.25 0 0; 0 0 0; 0 0 0];
        R = 1;
        xeig=[];
        qq = logspace(-3,2,100);
        
        xopenloop = eig(A_w);
        w = logspace(-2,2,100);
        t = linspace(0,1);
        
        B_cl = [-1;0;0];
        C_cl = eye(size(A_w));
        D_cl = 0.*C_cl*B_cl;
        rtd = 180/pi;
        
        for i = 1:prod(size(qq));
            Q(1,1) = qq(i);
            [K_w, S_w, E_w] = lqr(A_w, B_w, Q, R);
            A_cl = A_w - B_w*K_w;
            xx = eig(A_cl);
            xeig = [xeig;xx];
            [re,im] = nyquist(A_w,B_w,K_w,0,1,w); %wont work with Common Controller
            L=(re+sqrt(-1)*im)';
            mag = abs(L);
            stabRob = ones(size(L))+ones(size(L))./L;
            minStabRob = min(abs(stabRob));
            retDiff = ones(size(L))+L;
            minRetDiff = min(abs(retDiff));
            mag_dB = 20.*log10(mag)';
            wc = crosst(mag_dB, w);
            wiggle_sys = ss(A_cl, B_cl, C_cl, D_cl);
            y = step(wiggle_sys, t);
            az = y(:,2);
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
            dmax = rtd*max(abs(y(:,2)))*32.174;
            ddmax = rtd*max(abs(y(:,3)))*32.174;
            metric=[ qq(i) minRetDiff minStabRob wc tau_r tau_s azmin azmax dmax ddmax];
            data(i,:) = metric;
            
            figure(1)
            plot(real(xeig),imag(xeig), '*')
            
            figure(2)
            plot(wc,tau_r, 'r*')
            hold on
            plot(wc,tau_s, 'o')
            
            figure(3)
            %plot(
            
        end
        
        
       
    end
    
end
