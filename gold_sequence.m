function [gold_pack] = gold_sequence(NcellID)
    m_seq = zeros([1 31], 'int8');
    m_seq(1) = 1;
    size(m_seq);
    for i = 6:31
	    m_seq(i) = mod((m_seq(i-5)+m_seq(i-3)),2);
    end
    mu = zeros([1 31],'int8');
    dec = 2^((5+1)*0.5)+1;
    for i = 0:30
        tmp = mod((i*dec),31)+1;
	    mu(i+1) = m_seq(tmp);
    end
    gold_pack = zeros([33 31],'uint8');
    gold_pack(1, :) = m_seq;
    gold_pack(2, :) = mu;
    for i = 3:33
        for j = 1:31
		    gold_pack(i,j) = mod((m_seq(j)+mu(j)),2);
        end
        tmp = mu(31);
        mu(2:31) = mu(1:30);
        mu(1) = tmp;
        %mu(size(mu)-1),mu(0:size(mu)-1)]
    end
    disp(gold_pack)
end