function PolarEncoding
    InputBits % последовательность входных бит
    NumberOfEncodedBits % Количество закодированных битов
    PowerToDetermineN % Степень, в которую необходимо возвести 2, чтобы получить длину закодированной последовательнгости 
    RateMatchingOutSeqLength %


    n_min = 5;
    n_max = 9;
    I_IL = 1;
    n_PC = 0; % Количество битов проверки четности (number of parity check bits)
    nwm_PC = 0;
    R_min = 1/8;

    % Определение количества закодированных битов
    if RateMatchingOutSeqLength <= (9/8)*2^(log2(RateMatchingOutSeqLength)-1) && NumOfBitsToEncode/RateMatchingOutSeqLength < 9/16
        n1 = log2(RateMatchingOutSeqLength) - 1;
    else
        n1 = log2(RateMatchingOutSeqLength);
    end
    n2 = log2(NumOfBitsToEncode/obj.R_min);
    
    obj.NumberOfEncodedBits = max(min(n1, min(n2, obj.n_max), obj.n_min);

end 

