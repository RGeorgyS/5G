% 3GPP TS 38.212 7.1.3
%function datancrc = PBCH_CRCGen(data)
    %data -> data+crc
    data = [1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9]
    D=[24 23 21 20 17 15 13 12 8 4 2 1 0];
    len=length(data);
    
    dtemp = [data, zeros(1, 24)];

    crc=zeros(1, len);
    for i=1:len
        crc(i)=mod(sum(dtemp(i+D)),2);
    end
    datancrc = [data,crc];
%end