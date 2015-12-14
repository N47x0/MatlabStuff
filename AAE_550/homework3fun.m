function phi = homework3fun(x)
    % Here we unflatten the x variable to have the form:
    % Rows: Truss, Col: Parameter(Material, x-sec)
    % ex: for truss 1
    % x(1,1): Material Choice
    % x(1,2): Truss x-sec Area
    x = [x(1) x(2);
         x(3) x(4);
         x(5) x(6)];
    
    % Data
    L2 = 1.2; % meters
    L1 = L2/sind(45);
    L3 = L1;    
    L = [L1 L2 L3];
    
    % Material Parameter table for easy choosing:
    %             E [Pa] rho[kg/m^3]  sigma_y [Pa]
    matParams = [ 68.9e9    2700        55.2e6;   % Aluminum
                 116e9      4500       140e6;     % Titanium
                 205e9      7872       285e6;     % Steel
                 207e9      8800        59.0e6];  % Nickel
             
    sigma = stressHW3(x(:,2), ...
            [matParams(x(1,1),1) matParams(x(2,1),1) matParams(x(3,1),1)]);
    
    mass = [matParams(x(1,1),2) matParams(x(2,1),2) matParams(x(3,1),2)]...
           .*x(:,2)'.*L;

    g = [];
    for i=1:numel(x(:,1))
       g = [g  (sigma(i) - matParams(x(i,1), 3))];
    end

    P = 0.0;    % initialize penalty function
    for i = 1:numel(g)
        P = P + 1 * max(0,g(i));  % use c_j = 10 for all bounds
    end
    phi = sum(mass) + P;
    
end