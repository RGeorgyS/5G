function EncodedSequence = PolarEncoding(InputInterleavedBits, NumOfBitsToEncode, NumberOfParityCheckBits, RateMatchingOutSeqLength, QN_I)
    % InputBits - последовательность входных бит
    % PowerToDetermineN - cтепень, в которую необходимо возвести 2, чтобы получить длину закодированной последовательнгости 
    % RateMatchingOutSeqLength 
    % K (NumOfBitsToEncode) - количество бит, которые предстоит кодировать
    % После кодирования мы получаем массив OutSequence длиной N = NumberOfEncodedBits = 2^n
    % NumberOfEncodedBits - длина выходной закодированной
    % последовательности

    % NumberOfParityCheckBits = 0; % Количество битов проверки четности (number of parity check bits). В стандарте также n_PC

    n_min = 5;
    n_max = 9;
    I_IL = 1;
    nwm_PC = 0;
    R_min = 1/8;

    % Определение степени, в которую нужно возвести 2, чтобы получить 
    % количество закодированных битов (NumberOfEncodedBits)
    if RateMatchingOutSeqLength <= (9/8)*2^(log2(RateMatchingOutSeqLength)-1) && NumOfBitsToEncode/RateMatchingOutSeqLength < 9/16
        n1 = ceil(log2(RateMatchingOutSeqLength)) - 1;
    else
        n1 = ceil(log2(RateMatchingOutSeqLength));
    end
    n2 = ceil(log2(NumOfBitsToEncode/R_min));


    % Степень двойки
    Power = max(min(n1, min(n2, n_max)), n_min);
    % Количество закодированных битов
    NumberOfEncodedBits = 2^Power;

    % Определяем матрицу G_2
    G_2 = ones(2, 2);
    G_2(1, 2) = 0;

    % Возводим G_2 в степень Кронекера Power раз
    G_N = G_2;
    for i=1:Power-1
        G_N = kron(G_2, G_N);
    end
    % Индексы битов проверки четности занимают (n_PC - nwm_PC) = 
    % (NumberOfParityCheckBits - nwm_PC) наименее
    % надежных индексов в QN_I
    % Для ситуации NumberOfParityCheckBits = nwm_PC придется прибавить
    % единицу для корректного обращения к элементам массива QN_I
    QN_PC = QN_I(1:(NumberOfParityCheckBits - nwm_PC) + 1); 

    % Генерируем выходную последовательность
    k = 1;
    % Инициализируем выходную последовательность нулями
    OutSequence = zeros(1, NumberOfEncodedBits);

    if NumberOfParityCheckBits > 0
        y_0 = 0;
        y_1 = 0;
        y_2 = 0;
        y_3 = 0;
        y_4 = 0;
        
        for n = 1:NumberOfEncodedBits
            y_t = y_0;
            y_0 = y_1;
            y_1 = y_2;
            y_2 = y_3;
            y_3 = y_4;
            y_4 = y_t;
            
            if ismember(n-1, QN_I)
                if ismember(n-1, QN_PC)
                    OutSequence(n) = y_0;
                else
                    OutSequence(n) = InputInterleavedBits(k);
                    k = k + 1;
                    y_0 = xor(y_0, OutSequence(n));
                end
            else
                OutSequence(n) = 0;
             end
        end
    else
        for n = 1:NumberOfEncodedBits
            if ismember(n, QN_I)
                OutSequence(n) = InputInterleavedBits(k);
                k = k + 1;
            else
                OutSequence(n) = 0;
            end
        end
    end

    % Получаем окончательный результат. Выходная последовательность
    % закодированных бит
    EncodedSequence = OutSequence*G_N;
end 

