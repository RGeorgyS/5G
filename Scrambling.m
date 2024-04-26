classdef Scrambling
    % Переименовать переменные так, чтобы было понятно ее назначение
    properties
        InputBits % последовательность входных бит
        InterleavedBits 
        A
        L % размер транспортного блока
        CRCsequence % последовательность после добавления CRC
        N
        ScrambledBits
    end

    properties(Constant)
        G = [16, 23, 18, 17, 8, 30, 10, 6, 24, 7, 0, 5, 3, 2, 1, 4, 9, 11, 12, 13, 14, 15, 19, 20, 21, 22, 25, 26, 27, 28, 29, 31];
    end

    methods
        % конструктор
        function obj = Scrambling(inputBits, L, A)
            obj.InputBits = inputBits;
            obj.L = L;
            obj.A = A;
            obj.ScrambledBits = zeros(1, A);
        end
        % перемежение согласно таблице 
        function Interleave(obj, Data)
            obj.InterleavedBits = zeros(1, 32);
            obj.InterleavedBits(obj.G+1) = Data;
        end
        % Добавление CRC
        function AddCRC(obj, InterleavedBits)
            if obj.L <= 3824
                obj.N = 16;
                % obj.CRCsequence = 
            else 
                obj.N = 24;
                % obj.CRCsequence = 
            end
        end
        % Функция скремблирования
        function obj = Scramble(obj, Lmax, NcellID, ThirdLSB, SecondLSB)
            % Lmax is the number of candidate SS/PBCH blocks in a half frame according to Clause 4.1
            if Lmax == 4 || Lmax == 8
                M = obj.A - 3;
            elseif Lmax == 10
                M = obj.A - 4;
            elseif Lmax == 20
                M = obj.A - 5;
            elseif Lmax == 64
                M = obj.A - 6;
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

            % Создание скремблирующей последовательности c(i)
            gold_pack6 = gold_sequence(NcellID);
            c = gold_pack6(4, :);

            % Начало скремблирования
            i = 1;
            j = 1;
            s = zeros(1,length(obj.A));

            belong_candidate_SSPBCH = false;

            while i <= obj.A
                if belong_candidate_SSPBCH
                    s(i) = 0;
                else
                    s(i) = c(j + v*M);
                    % obj.ScrambledBits = c(j + v*M);
                    j = j + 1;
                end
                i = i + 1;
            end
            index = 1:obj.A;
            obj.ScrambledBits(index) = mod((obj.InputBits(index)+s(index)), 2);
            
        end
    end 
end

