% Получение наборов индексов Q^N_I, Q^N_F
function [QN_I, QN_F] = PBCH_RateMatchingForPolarCode(InputBits, NumOfBitsToEncode, RateMatchingOutSeqLength, NumberOfParityCheckBits, PolarSeq, IndexesAfterSubBlockInterleaving)
    % InputBits - последовательность входных бит  
    % NumOfBitsToEncode Количество закодированных битов. В стандарте обозначается K
    % RateMatchingOutSeqLength - В стандарте обозначается E
    % NumberOfParityCheckBits или n_PC равно нулю. Количество битов проверки четности (number of parity check bits)
    % PolarSeq - последовательность индексов битов, расположенных по
    % возрастанию надежности (см. TS 38.212 5.3.1.2)
    % IndexesAfterSubBlockInterleaving - индексы битов после перемежения

    % длина входной последовательности
    N = length(InputBits);
    % Инициализируем множество QN_Ftmp
    QN_Ftmp = [];
    % Получение наборов индексов Q^N_I, Q^N_F
    if RateMatchingOutSeqLength < N
        if NumOfBitsToEncode/RateMatchingOutSeqLength <= 7/16
            for n = 1:N-RateMatchingOutSeqLength-1
                QN_Ftmp = union(QN_Ftmp, IndexesAfterSubBlockInterleaving);
            end
            if RateMatchingOutSeqLength >= 3*N/4
                QN_Ftmp = union(QN_Ftmp, ceil(0:3*N/4 - RateMatchingOutSeqLength/2) - 1);
            else
                QN_Ftmp = union(QN_Ftmp, ceil(0:9*N/16 - RateMatchingOutSeqLength/2) - 1);
            end
        else
            for n = RateMatchingOutSeqLength:N
                QN_Ftmp = union(QN_Ftmp, IndexesAfterSubBlockInterleaving(n));
            end
        end
    end
    % Вычитаем из набора индексов PolarSeq набор QN_Ftmp, причем порядок
    % должен остаться тем же (для этого устанавливаем setOrder = 'stable'
    QN_Itmp = setdiff(PolarSeq, QN_Ftmp, 'stable');

    % QN_I содержит (K + n_PC) = (NumOfBitsToEncode +
    % NumberOfParityCheckBits) самых надежных индексов из QN_Itmp.
    % Так как индексы в QN_Itmp расположены в порядке возрастания
    % надежности, то достаточно взять значения, начиная с индекса 
    % length(PolarSeq) - (NumOfBitsToEncode + NumberOfParityCheckBits) до конца
    QN_I = QN_Itmp(length(PolarSeq) - (NumOfBitsToEncode + NumberOfParityCheckBits):end);
    QN_F = setdiff(PolarSeq, QN_Itmp, 'stable');
end
        






