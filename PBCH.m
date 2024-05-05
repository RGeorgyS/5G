classdef PBCH
    % A_ %payload size, any; 
    % SFN %system frame number; %10 bits; 
    % SFN_PBCH = SFN(4:-1:1); %4 bits; 
    % hrf = 5; %half frame bit; 
    % L_max_ %10, 20, 64 or another; L_max - max number of ss/pbch block indexes in a cell; L_max_ - number of block indexes defined block patterns 
    % block_index %binary number; 
    % k_ssb %offsetToPointA [38.211 7.4.3.1]; 5 bits;

    %Playload generation
    %Scramling
    %CRC
    %Channel coding
    %Rate matching: Sub-block interleaver, Bit selection, Interleavingcoded bits


    properties
        data = 0;
        SFN = 0;
        hrf = 0;
        L_max = 0;
        block_index = 0;
        k_ssb = 0 ;
        RateMatchingOutSeqLength = 864; % в стандарте обозначено E
        I_BIL = 0;
        isPayload = false;
        isCRC = false;
        isScrambled = false;
        isChannelCodined = false;
        isRM = false;

        % Индексы битов, которые будут переданы в блоке SS/PBCH
        % (используется в функции скремблирования)
        IndexesOfBitsInCandidateSSPBCH
        % Третий наименее значимый бит SFN
        ThirdLSB = 0;
        % Второй наименее значимый бит SFN
        SecondLSB = 0;
    end

    methods
        function obj = PBCH(data, SFN, hrf, L_max, block_index, k_ssb)
            % arguments
            %     data (1:) {mustBeNumeric}
            %     SFN (1, 4) {mustBeNumeric}
            %     hrf (1,1) {mustBeNumeric}
            %     L_max {mustBeNumeric}
            %     block_index {mustBeNumeric}
            %     k_ssb (1, 5) {mustBeNumeric}
            % end

            if nargin < 1
                obj.data = 0;
                obj.SFN = 0;
                obj.hrf = 0;
                obj.L_max = 0;
                obj.block_index = 0;
                obj.k_ssb = 0;
            
            elseif nargin < 2
                obj.data = data;
                obj.SFN = 0;
                obj.hrf = 0;
                obj.L_max = 0;
                obj.block_index = 0;
                obj.k_ssb = 0;

            elseif nargin < 3
                obj.data = data;
                obj.SFN = SFN;
                obj.hrf = 0;
                obj.L_max = 0;
                obj.block_index = 0;
                obj.k_ssb = 0;
            
            elseif nargin < 4
                obj.data = data;
                obj.SFN = SFN;
                obj.hrf = hrf;
                obj.L_max = 0;
                obj.block_index = 0;
                obj.k_ssb = 0;
            
            elseif nargin < 5
                obj.data = data;
                obj.SFN = SFN;
                obj.hrf = hrf;
                obj.L_max = L_max;
                obj.block_index = 0;
                obj.k_ssb = 0;
            
            elseif nargin < 6
                obj.data = data;
                obj.SFN = SFN;
                obj.hrf = hrf;
                obj.L_max = L_max;
                obj.block_index = block_index;
                obj.k_ssb = 0;

            else
                obj.data = data;
                obj.SFN = SFN;
                obj.hrf = hrf;
                obj.L_max = L_max;
                obj.block_index = block_index;
                obj.k_ssb = k_ssb;
            end
        end

        function payload = PayloadGen(obj) %функция класса
            payload = PBCH_PayloadGen(obj.data, obj.SFN, obj.hrf, obj.L_max, obj.block_index, obj.k_ssb); %внешняя функция
        end

        % Скремблирование
        function ScrambledBits = Scrambling(obj, InputBits, NcellID)
            % Последовательность Голда c(i) должна быть сформирована следующим образом 
            gold_pack = gold_sequence(NcellID);
            FirstGoldSeq = gold_pack(3, :); % в данном случае индекс строки 3 соответствует первой последоваетльности из 31 возможной
            % Выходная последовательность
            ScrambledBits = PBCH_Scramble(InputBits, obj.L_max, obj.IndexesOfBitsInCandidateSSPBCH, obj.ThirdLSB, obj.SecondLSB, FirstGoldSeq);
        end

        % добавление CRC
        function SeqWithCRC = AddingCRC(ScrambledBits) 
            SeqWithCRC = PBCH_CRCGen(ScrambledBits);
        end

        % Реализация полярного кодирования 
        function EncodedSequence = PolarEncoding(obj, InterleavedBits, NumOfBitsToEncode, NumberOfParityCheckBits) 
            [QN_I, QN_F] = PBCH_RateMatchingForPolarCode(InputBits, NumOfBitsToEncode, obj.RateMatchingOutSeqLength, NumberOfParityCheckBits, PolarSeq, IndexesAfterSubBlockInterleaving);
            EncodedSequence = PBCH_PolarEncoding(InterleavedBits, NumOfBitsToEncode, NumberOfParityCheckBits, obj.RateMatchingOutSeqLength, QN_I);
        end
    end
end