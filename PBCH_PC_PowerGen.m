% 3GPP TS 38.212 7.1.4 -> 5.3.1.0
function power = PBCH_PC_PowerGen(NumOfBitsToEncode, RateMatchingOutSeqLength)
    %RateMatchingOutSeqLength = E
    %NumOfBitsToEncode = K
    % Определение степени, в которую нужно возвести 2, чтобы получить 
    % количество закодированных битов (NumberOfEncodedBits)
    n_min = 5;
    n_max = 9;
    R_min = 1/8;
   
    if RateMatchingOutSeqLength <= (9/8)*2^(log2(RateMatchingOutSeqLength)-1) && NumOfBitsToEncode/RateMatchingOutSeqLength < 9/16
        n1 = ceil(log2(RateMatchingOutSeqLength)) - 1;
    else
        n1 = ceil(log2(RateMatchingOutSeqLength));
    end
    n2 = ceil(log2(NumOfBitsToEncode/R_min));
    
    
    % Степень двойки
    power = max(min(n1, min(n2, n_max)), n_min);