classdef PBCH < handle
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
        hrf = 0;ThirdLSB
        L_max = 0;
        block_index = 0;
        k_ssb = 0 ;
        RateMatchingOutSeqLength = 864; % в стандарте обозначено E
        I_BIL = 0;
         % Индексы битов, которые будут переданы в блоке SS/PBCH
        % (используется в функции скремблирования)
        IndexesOfBitsInCandidateSSPBCH
        % Третий наименее значимый бит SFN
        SFN3Bit
        % Второй наименее значимый бит SFN
        SFN2Bit

        isPayload = false;
        isCRC = false;
        isScrambled = false;
        isChannelCodined = false;
        isRM = false;

       
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

        function PayloadGen(obj) %функция класса
           [obj.data, obj.SFN2Bit, obj.SFN3Bit, obj.IndexesOfBitsInCandidateSSPBCH] = PBCH_PayloadGen(obj.data, obj.SFN, obj.hrf, obj.L_max, obj.block_index, obj.k_ssb); %внешняя функция первичного перемежения
        end

        % Скремблирование
        function Scrambling(obj)
            % Последовательность Голда c(i) должна быть сформирована следующим образом 
            gold_pack = gold_sequence(NcellID);
            FirstGoldSeq = gold_pack(3, :); % в данном случае индекс строки 3 соответствует первой последоваетльности из 31 возможной
            % Выходная последовательность
            obj.data = PBCH_Scramble(obj.data, obj.L_max, obj.IndexesOfBitsInCandidateSSPBCH, obj.SFN3Bit, obj.SFN2Bit, FirstGoldSeq);
        end

        % добавление CRC
        function AddingCRC(obj) 
            obj.data = PBCH_CRCGen(obj.data);
        end
        
        % Перемежение (Interleaving)
        
        % Реализация полярного кодирования 
        function PolarEncoding(obj, NumberOfParityCheckBits)
            Power = PBCH_PC_PowerGen(length(obj.data), obj.RateMatchingOutSeqLength);
            interleaverIndexes = PBCH_RM_SBInterleaverIndexes(2^Power);
            [QN_I, QN_F] = PBCH_RM_QGen(Power, length(obj.data), obj.RateMatchingOutSeqLength, NumberOfParityCheckBits, PolarSeq, interleaverIndexes);
            %interleaver??
            obj.data = PBCH_PC_PolarEncoding(obj.data, NumberOfParityCheckBits, obj.RateMatchingOutSeqLength, QN_I);
        end

        % Реализация полярного кодирования 
        function RateMatching(obj)
            interleaverIndexes = PBCH_RM_SBInterleaverIndexes(length(obj.data));
            for n = 0:(length(obj.data)-1)
                obj.data(n+1) = obj.data(interleaverIndexes(n+1));
            end
            obj.data = PBCH_RM_BitSelect(obj.data, obj.RateMatchingOutSeqLength);
            obj.data = PBCH_RM_BitInterleaver(obj.data, obj.I_BIL);
            
        end
    end
end