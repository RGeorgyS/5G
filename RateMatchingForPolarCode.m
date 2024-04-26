% Получение наборов индексов Q^N_I, Q^N_F
function [QN_I, QN_F] = RateMatchingForPolarCode(InputBits, NumberOfEncodedBits, RateMatchingOutSeqLength, NumberOfParityCheckBits, Q_0)
    % InputBits % последовательность входных бит  
    % NumberOfEncodedBits % Количество закодированных битов. В стандарте обозначается K
    % RateMatchingOutSeqLength % В стандарте обозначается E
    % NumberOfParityCheckBits или n_PC равно нулю. Количество битов проверки четности (number of parity check bits)
    N = length(InputBits); % длина входной последовательности
    QN_Ftmp = [];
    % Получаем набор новых индексов и бит после перемежения
    [NewIndexes, InterleavedCodedBits] = SubBlockInterleaving(InputCodedBits);
    % Получение наборов индексов Q^N_I, Q^N_F
    if NumberOfEncodedBits < N
        if NumberOfEncodedBits/RateMatchingOutSeqLength <= 7/16
            for n = 1:N-RateMatchingOutSeqLength-1
                QN_Ftmp = union(QN_Ftmp, NewIndexes);
            end
            if RateMatchingOutSeqLength >= 3*N/4
                QN_Ftmp = union(QN_Ftmp, 0:3*N/4 - RateMatchingOutSeqLength/2 - 1);
            else
                QN_Ftmp = union(QN_Ftmp, 0:9*N/16 - RateMatchingOutSeqLength/2 - 1);
            end
        else
            for n = 1:N-1
                QN_Ftmp = union(QN_Ftmp, NewIndexes);
            end
        end
    end
    QN_Itmp = setdiff(Q_0, QN_Ftmp);
    QN_I = QN_Itmp(1:NumberOfEncodedBits+NumberOfParityCheckBits);
    QN_F = setdiff(Q_0, QN_Itmp);
end
        






