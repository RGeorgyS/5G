% TS 38.212 5.3.1.1
function InterleavedBits = PBCH_PC_Interleaving(InputBits, I_IL)
    
    % Максимальная длина последовательности, подлежащей перемежению
    MaxLengthOfSeqToInterleave = 164;
    
    % Индексы бит
    k = 1:length(InputBits);

    % Длина входной последовательности бит
    InputSeqLength = length(InputBits);

    % Последовательность индексов для перемежения (каждому индексу исходной
    % последовательности соответствует другой индекс из этой
    % последовательности)
    InterleavingIndex = zeros(1, InputSeqLength);

    % Инициализируем выходную последовательность
    InterleavedBits = zeros(1, InputSeqLength); 

    if I_IL == 0
        InterleavingIndex(k) = k;
    else
        % Вводим вспомогательный индекс i для заполнения InterleavingIndex
        i = 1;
        for m = 1:MaxLengthOfSeqToInterleave
            % Импортируем mat file с таблицей зависимости
            % InterleavingPattern от m
            InterleavingPattern = matfile("InterleavingPatternPmaxIL.mat");
            % Присваиваем переменной InterleavingPattern таблицу из InterleavingPatternPmaxIL.mat
            InterleavingPattern = InterleavingPattern.InterleavingPattern;
            % Операции по стандарту
            if InterleavingPattern(m) > MaxLengthOfSeqToInterleave - InputSeqLength
                InterleavingIndex(i) = InterleavingPattern(m) - (MaxLengthOfSeqToInterleave - InputSeqLength);
                i = i + 1;
            end
        end
    end
    % Формируем выходную последовательность
    InterleavedBits(k) = InputBits(InterleavingIndex(k) + 1);
end