% 3GPP TS 38.212 7.1.1
function [payload, SFN2Bit, SFN3Bit, SSPBCHBits] = PBCH_PayloadGen(data, SFN_PBCH, a_hrf, L_max_, block_index, k_ssb)
    % A_ %payload (input data) size, any; 
    % SFN %system frame number; %10 bits; 
    % SFN_PBCH = SFN(4:-1:1); %4 bits; 
    % a_hrf = 5; %half frame bit; 
    % L_max_ %10, 20, 64 or another; L_max - max number of ss/pbch block indexes in a cell; L_max_ - number of block indexes defined block patterns 
    % block_index %binary number; 
    % k_ssb %offsetToPointA [38.211 7.4.3.1]; 5 bits;
    
    reserved = 8; % const fo reserved bits
    A_ = length(data);
    %a_5-7
    if L_max_ == 10
        L_massive = [k_ssb(end), reserved, block_index(end)];
        SSPBCHBits = zeros(1,1); %массив для дальнейшего запоминания индексов
    
    elseif L_max_ == 20
        L_massive = [k_ssb(5), block_index(end), block_index(end-1)];
        SSPBCHBits = zeros(1,2);
    
    elseif L_max_ == 64
        L_massive = [block_index(end), block_index(end-1), block_index(end-2)];
        SSPBCHBits = zeros(1,3);

    else
        L_massive = [k_ssb(end), reserved, reserved];
        SSPBCHBits = [];
    end
    
    a = [data, SFN_PBCH, a_hrf, L_massive];
    
    % Таблица для организации перемежения
    interleaveTable = 1.+[16 23 18 17 8 30 10 6 24 7 0 5 3 2 1 4 9 11 12 13 14 15 19 20 21 22 25 26 27 28 29 31];
    
    %Interleaver%Перемежение
    A=A_+8;
    jSFN=0+1;
    jHRF=10+1;
    jSSB=11+1;
    jOTHER=14+1;
    
    interleaved = zeros(1,32);
    
    for i=1:A
        if i >= A_+1 && i <= A_+4 %SFN bits
            interleaved(interleaveTable(jSFN))=a(i);
            %запоминание индексов 2 и 3 бит SFN
            if i == A_+2
                SFN2Bit = interleaveTable(jSFN);
            end

            if i == A_+3
                SFN3Bit = interleaveTable(jSFN);
            end
   
            jSFN = jSFN+1;
        elseif i == A_+5 %hrf
            interleaved(interleaveTable(jHRF))=a(i);
        elseif i >= A_+6 && i<=A+8 % L_massive
            interleaved(interleaveTable(jSSB))=a(i);
            %запоминание индексов бит индексов бит SSPBCH
            if i == A_+8 && L_max_ == 10
                SSPBCHBits(i - (A_ + 7)) = interleaveTable(jSSB);
            elseif (i == A_+8 || i == A_+7) && L_max_ == 20
                SSPBCHBits(i - (A_ + 7)) = interleaveTable(jSSB);
            elseif (i == A_+8 || i == A_+7 || i == A_+7) && L_max_ == 60
                SSPBCHBits(i - (A_ + 7)) = interleaveTable(jSSB);
            end

            jSSB = jSSB+1;
        else
            interleaved(interleaveTable(jOTHER))=a(i);
            jOTHER = jOTHER+1;
        end
    end
    
    payload = interleaved;
end