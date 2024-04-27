function bselect = PBCH_RM_BitSelect(data, E)
    y = data;
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

    bselect = e;