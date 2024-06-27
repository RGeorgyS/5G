function PssSignal = generatePssByCellInfo(cellId, frameCount)
    %if (or((cellId < 0), (cellId > 0), (frame <= 0)))
    %    PssSignal = zeros(1,128);
    %elseif    
        function x = x_ss(m, start_seq, flag) %создание последовательности x
            x_seq = zeros ([1 127]); 
            for i = 1:128 
                if (i < 8) 
                    x_seq(i) = start_seq(i); 
                end 
                if (flag == 1) 
                    x_seq(i + 7) = mod(x_seq(i+4) + x_seq(i), 2); %PSS и SSS 
                elseif (flag == 2) 
                    x_seq(i + 7) = mod(x_seq(i+1) + x_seq(i), 2); %SSS 
                end 
            end 
            x = x_seq(m); 
        end
        function d_pss = PSS_Lab(N_ID_2) %создание последовательности PSS
            start_seq = [0 1 1 0 1 1 1]; %перевернуто для упрощения циклических операций
            d = zeros([1 127]); 
            for n = 1:128 
                m = mod(n + 43 * N_ID_2, 127) + 1; 
                d(n) = 1 - 2 * x_ss(m, start_seq, 1); 
            end 
            d_pss = d; 
        end
        PssSignal = zeros(1,(128*frameCount)); %выделение памяти под сигнал
        PssSignal_unit = PSS_Lab(cellId); %один "видеоимпульс" сигнала
        for i = 1:frameCount %создание последовательности из копий
            PssSignal((i-1)*128+1:128*i) = PssSignal_unit; 
        end
    %end
end