function ratematched = PBCH_rate_matching(data, K)
    %data -> y -> e -> f
    E = 864;
    I_BIL = 0;
    
    %sub-block interleaver
    N = length(data);
    
    
    y = zeros(1,N);
    J = zeros(1,N);
    P = 1+[0 1 2 4 3 5 6 7 8 16 9 17 10 18 11 19 12 20 13 21 14 22 15 23 24 25 26 28 27 29 30 31];
     for n=0:(N-1)
         i = floor(32*(n+1)/N);
         J(n+1)=P(i)*(N/32)+mod(n+1, N/32);
         y(n+1)=data(J(n+1));
     end
  
    %bit selection
    e = zeros(1, E-1);
    if E >= N
        for k = 0:(E-1)
            e(k+1) = y(mod(k+1,N));
        end
    else
        if (K/E) <= (7/16)
            for k=0:(E-1)
                e(k+1) = y(k+1+N-E);
            end
        else
            for k = 0:(E-1)
                e(k+1) = y(k+1);
            end
        end
    end
    
    %bit interleaver
    %T(T+1)/2 >= E
    T = 0;
    temp = ceil(sqrt(2*E));
    while (temp*(temp+1)) >= E
        T = temp;
        temp = temp - 1;
    end
    
    v = zeros(T, T);
    f = zeros(1, T*(T+1)/2);
    
    if I_BIL == 1
        k = 0;
        for i = 0:(T-1)
            for j = 0:(T-1-j)
                if k < E
                    v(i+1,j+1) = e(k+1);
                else
                    v(i+1,j+1) = null;
                end
                k = k + 1;
            end
        end
        k = 0;
        for j = 0:(T-1)
            for i = 0:(T-1-j)
                if v(i+1, j+1) ~= null
                    f(k+1) = v(i+1,j+1);
                    k = k+1;
                end
            end
        end
    else
        for i = 0:(E-1)
            f(i)=e(i);
        end
    end
    ratematched = f;
end