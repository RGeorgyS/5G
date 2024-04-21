function datancrc = PBCH_CRC_gen(data)
    %data -> data+crc
    D=[24 23 21 20 17 15 13 12 8 4 2 1 0];
    len=length(data);
    
    dtemp = [data, zeros(1, 24)];

    crc=zeros(1, len);
    for i=1:len
        crc(i)=mod(sum(dtemp(i+D)),2);
    end
    datancrc = [data,crc];
end