% ESE-543-Hw7
% Ignacio Soriano
% 1.a)

k1 = 5;
k2 = -10;

s = tf('s');
h11 = 3.04/s;
h12 = -278.2/(s*(s+6.02)*(s+30.3));
h21 = 0.052/s;
h22 = -206.6/(s*(s+6.02)*(s+30.3));
H = [h11 h12;h21 h22];
KH = diag([k1 k2])*H;
rdif = eye(2) + KH;

figure(1);
nyquist(KH);
grid on
% There are zero encirclements. This corresponds with zero RHP poles.

figure(2)
bode(KH);
grid on


robustMat = eye(2) + inv(KH)

w1 = logspace(0,5,500);
temp = 0;
s_min = 1000000000;
for count=1:length(w1) 
    temp = min(svds(sMatrix(w1(count))));
    if (temp < s_min)
        s_min = temp;    
    end
end
s_min

figure(3);
fplot(@sMatrix, [1 100]);
grid on
xlabel('Frequency [w]');
ylabel('Min Singular Val');
title('Return Differnece Matrix Min Singular Values');
set(gca,'xscale','log');


s_min = 10000000;
for count=1:length(w1) 
    temp = min(svds(robustnessMatrix(w1(count))));
    if (temp < s_min)
        s_min = temp;    
    end
end
s_min

figure(4);
fplot(@robustnessMatrix, [1 100], 'r')
grid on
xlabel('Frequency [w]');
ylabel('Min Singular Val');
title('Robustness Matrix Min Singular Values');
set(gca,'xscale','log');

figure(5);
grid on
sigma(rdif);
sigma(KH, [], 2);
grid on
figure(6);
sigma(KH, [], 3);
grid on

% Run the code to find min
min(sigma(KH,[], 2))
min(sigma(KH,[], 3))

% Doing it another way for comparison
for i=1:numel(w1);
    S = sqrt(-1)*w1(i);
    h11 = 3.04/S;
    h12 = -278.2/(S*(S+6.02)*(S+30.3));
    h21 = 0.052/S;
    h22 = -206.6/(S*(S+6.02)*(S+30.3));
    H = [h11 h12;h21 h22];
    KH = diag([k1 k2])*H;
    rdif = eye(2) + KH;
    x1(i) = det(rdif);
end
