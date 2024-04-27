% Функция для перемежения подблоков и получения выходной
% последовательности
function [NewIndexes, InterleavedCodedBits] = PBCH_SubBlockInterleaving(InputCodedBits)
    P = [0, 1, 2, 4, 3, 5, 6, 7, 8, 16, 9, 17, 10, 18, 11, 19, 12, 20, 13, 21, 14, 22, 15, 23, 24, 25, 26, 28, 27, 29, 30, 31];
    N = length(InputCodedBits);
    % Инициализируем последовательности новых индексов и перераспределенных
    % бит
    NewIndexes = zeros(1, N);
    InterleavedCodedBits = zeros(1, N);

    % Работаем в предположении, что N <= 32!!
    for n = 1:N
            i = floor(32*n/N);
            NewIndexes(n) = floor(P(i)*(N/32)+mod(n - 1, N/32));
            
            % получение выходной последовательности
            InterleavedCodedBits(n) = InputCodedBits(NewIndexes(n) + 1);
    end
end    

