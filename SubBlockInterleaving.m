% Функция для перемежения подблоков и получения выходной
% последовательности
function [NewIndexes, InterleavedCodedBits] = SubBlockInterleaving(InputCodedBits)
    P = [0, 1, 2, 4, 3, 5, 6, 7, 8, 16, 9, 17, 10, 18, 11, 19, 12, 20, 13, 21, 14, 22, 15, 23, 24, 25, 26, 28, 27, 29, 30, 31];
    N = length(InputCodedBits);
    % Инициализируем последовательности новых индексов и перераспределенных
    % бит
    NewIndexes = zeros(1, N);
    InterleavedCodedBits = zeros(1, N);
    for n = 1:N
        i = 32*n/N;
        NewIndexes(n) = P(i)*(N/32)+mod(n, N/32);
        
        % получение выходной последовательности
        InterleavedCodedBits(n) = InputCodedBits(NewIndexes(n) + 1);
    end
end    

