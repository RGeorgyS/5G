function EncodedSequence = PolarEncoding(InputBits, NumberOfEncodedBits, RateMatchingOutSeqLength, NumberOfParityCheckBits)
    % InputBits % последовательность входных бит
    % NumberOfEncodedBits % Количество закодированных битов
    % PowerToDetermineN % Степень, в которую необходимо возвести 2, чтобы получить длину закодированной последовательнгости 
    % RateMatchingOutSeqLength %

    n_min = 5;
    n_max = 9;
    I_IL = 1;
    n_PC = 0; % Количество битов проверки четности (number of parity check bits)
    nwm_PC = 0;
    R_min = 1/8;

    % Defining matrix G2
    G_2 = ones(2, 2);
    G_2(1, 2) = 0;

    G_N = G_2;
    for i=1:n
        % Kronecker power of matrix G2
        G_N = kron(G_N, G_2);
    end

    % Определение количества закодированных битов
    if RateMatchingOutSeqLength <= (9/8)*2^(log2(RateMatchingOutSeqLength)-1) && NumOfBitsToEncode/RateMatchingOutSeqLength < 9/16
        n1 = log2(RateMatchingOutSeqLength) - 1;
    else
        n1 = log2(RateMatchingOutSeqLength);
    end
    n2 = log2(NumOfBitsToEncode/R_min);
    
    NumberOfEncodedBits = max(min(n1, min(n2, n_max), n_min);

    % Генерируем выходную последовательность
    k = 0;
    y = zeros(1, length(InputBits));

    OutSequence = zeros(1, length(InputBits));

    if NumberOfParityCheckBits > 0
        y(1) = 0;
        y(2) = 0;
        y(3) = 0;
        y(4) = 0;
        y(5) = 0;
        
        for n = 1:length(InputBits)
            y_t = y(0);
            y(1) = y(1);
            y(2) = y(2);
            y(3) = y(3);
            y(4) = y(5);
            y(5) = y_t;
            
            [QN_I, QN_F] = RateMatchingForPolarCode(InputBits, NumberOfEncodedBits, RateMatchingOutSeqLength, NumberOfParityCheckBits, Q_0);
            if ismember(n, QN_I)
                if ismember(n, QN_PC)
                    OutSequence(n) = y(1);
                else
                    OutSequence(n) = y(1);
                end
            end
end 

