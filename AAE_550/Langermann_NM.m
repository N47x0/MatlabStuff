function phi = Langermann_NM(x)

    c = [3 10 2 6 1 10 1 3 5 7];

    c = c';

    A= [8 7 6  1 4 6 6 9 5 1;
        4 6 10 7 4 4 5 5 9 10];
    A = A';

    f=0.0;

    for i=1:numel(c)
        innSum = 0.0;
        
        for j=1:numel(x)
           innSum = innSum +  (x(j)-A(i,j))^2;
        end
         
        f = f + c(i)*exp(-innSum/pi)*cos(pi*innSum);
    end

    
    g(1) = - x(1);  % enforces lower bound
    g(2) = - x(2);
    g(3) = x(1) - 10; % enforces upper bound
    g(4) = x(2) - 10;

    P = 0.0;    % initialize penalty function
    for i = 1:numel(g)
        P = P + 10 * max(0,g(i));  % use c_j = 10 for all bounds
    end
    phi = f + P;
    
end