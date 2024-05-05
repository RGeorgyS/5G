% 3GPP TS 38.212 7.1.5 -> 5.4.1.3
function bitinterleaved = PBCH_RM_BitInterleaver(data, I_BIL)
    %T(T+1)/2 >= E
    e = data;
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

    bitinterleaved = f;
end