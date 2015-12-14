function f = LangermannGA(x)

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
    
end