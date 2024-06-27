classdef SsGenerator
    % SsGenerator generates PSS and SSS
    methods (Static)
        function [pss,sss]=getSsSignalsByCellInfo(NCellId)
            % returns sync signals for NCellId

            arguments
                NCellId (1,1)
                % physical layer cell identity; see [38.211,7.4.2.1]
            end
            pss=PssGenerator.generatePssByCellInfo(NCellId);
            sss=SssGenerator.generateSssByCellInfo(NCellId);
        end
    end
end