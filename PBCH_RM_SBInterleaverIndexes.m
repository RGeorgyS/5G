% 3GPP TS 38.212 7.1.5 -> 5.4.1.1
function sbinterleavedindexes = PBCH_RM_SBInterleaverIndexes(lenghtOfData)
%Возвращает индексы перемежения 

    J = zeros(1,lenghtOfData);
    P = 1+[0 1 2 4 3 5 6 7 8 16 9 17 10 18 11 19 12 20 13 21 14 22 15 23 24 25 26 28 27 29 30 31];
    for n=0:(lenghtOfData-1)
     i = floor(32*(n+1)/lenghtOfData);
     J(n+1)=P(i)*(lenghtOfData/32)+mod(n+1, lenghtOfData/32);
    end

    sbinterleavedindexes = J;
     
