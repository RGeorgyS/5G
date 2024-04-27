function sbinterleaved = PBCH_RM_SBInterleaver(data)
    N = length(data);
    
    y = zeros(1,N);
    J = zeros(1,N);
    P = 1+[0 1 2 4 3 5 6 7 8 16 9 17 10 18 11 19 12 20 13 21 14 22 15 23 24 25 26 28 27 29 30 31];
    for n=0:(N-1)
     i = floor(32*(n+1)/N);
     J(n+1)=P(i)*(N/32)+mod(n+1, N/32);
     y(n+1)=data(J(n+1));
    end

    sbinterleaved = y;
     
