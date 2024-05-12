% 3GPP TS 38.212 7.1.2
function ScrambledBits = PBCH_Scramble(InputBits, L, IndexesOfBitsInCandidateSSPBCH, ThirdLSB, SecondLSB)

    % Длина входной последовательности
    A = length(InputBits);
    % L - количество претендующих SS/PBCH блоков в подкадре (is the number of
    % candidate SS/PBCH blocks in a half frame according to Clause 4.1)
    if L == 4 || L == 8
        M = A - 3;
    elseif L == 10
        M = A - 4;
    elseif L == 20
        M = A - 5;
    elseif L == 64
        M = A - 6;
    end
    
    % Определяем значение v
    if ThirdLSB == 0 && SecondLSB == 0
        v = 0;
    elseif ThirdLSB == 0 && SecondLSB == 1
        v = 1;
    elseif ThirdLSB == 1 && SecondLSB == 0
        v = 2;
    elseif ThirdLSB == 1 && SecondLSB == 1
        v = 3;
    end
    
    % Основную скремблирующую последовательность c(i) извлекаем из файла
    % ScramblingSequence
    ScramblingSequenceFile = matfile("ScramblingSequenceFile.mat");
    % Записываем массив 1x1046975 в переменную ScramblingSeq
    ScramblingSeq = ScramblingSequenceFile.ScramblingSequence;

    % Генерируем вспомогательную скремблирующую последовательность s(i)
    i = 1;
    j = 1;
    s = zeros(1, A);
 
    while i <= A
        % проверяем, является ли индекс текущего бита принадлежащим блокам 
        % SS/PBCH, претендующим на передачу
        if ismember(i, IndexesOfBitsInCandidateSSPBCH)
            s(i) = 0;
        else
            s(i) = ScramblingSeq(j + v*M);
            j = j + 1;
        end
        i = i + 1;
    end

    % Генерируем выходную последовательность
    index = 1:A;
    ScrambledBits(index) = mod((InputBits(index)+s(index)), 2);
end