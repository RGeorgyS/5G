classdef PssGenerator
    % PssGenerator represents generator for
    % primary sync. signal [38.211, 7.4.2.2]

    methods (Static)
        function PssSignal = generatePssByCellInfo(cellId)
            % generates PSS signal [38.211, 7.4.2.2]
            arguments
               cellId (1,1)
               % physical layer cell identity; see [38.211,7.4.2.1]
            end
            m_seq = mSequence(7, [0, 1, 1, 0, 1, 1, 1],[0,1,0,0,0,1,0,0]);
            PssSignal = zeros([1 127]); 
            for n = 0:126 
                m =  mod(n + 43 * mod(cellId, 3), 127) + 1; 
                PssSignal(n+1) = 1 - 2 * m_seq(m);     
            end
        end
    end
end