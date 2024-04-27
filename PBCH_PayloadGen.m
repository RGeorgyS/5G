function payload = PBCH_PayloadGen(payload, SFN_PBCH, a_hrf, L_max_, block_index, k_ssb)
    % A_ %payload size, any; 
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
    
    elseif L_max_ == 20
        L_massive = [k_ssb(5), block_index(end), block_index(end-1)];
    
    elseif L_max_ == 64
        L_massive = [block_index(end), block_index(end-1), block_index(end-2)];
    else
        L_massive = [k_ssb(end), reserved, reserved];
    end
    
    a = [payload, SFN_PBCH, a_hrf, L_massive];
    
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
            jSFN = jSFN+1;
        elseif i == A_+5 %hrf
            interleaved(interleaveTable(jHRF))=a(i);
        elseif i >= A_+6 && i<=A+8 % L_massive
            interleaved(interleaveTable(jSSB))=a(i);
            jSSB = jSSB+1;
        else
            interleaved(interleaveTable(jOTHER))=a(i);
            jOTHER = jOTHER+1;
        end
    end
    
    payload = interleaved;
end