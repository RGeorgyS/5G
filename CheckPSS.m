function [NID2, PSSTimeSlotIndex] = CheckPSS(ReceivedBlock)
    for NID2 = [0, 1, 2]
        % Получаем последовательность PSS для определенного индекса NID2
        PssSequence = fft(PssGenerator.generatePssByCellInfo(NID2));

        % Массив, в который будет сохраняться 
        corr = zeros(1, size(ReceivedBlock, 2));

        % ReceivedBlock = abs(ReceivedBlock);

        % Проходим по столбцам принятого блока
        for columnIndex = 1:size(ReceivedBlock, 2)
            % вычисляем КФ между PSS последовательностью и текущим столбцом
            % принятого блока. tmpcorr - массив со всеми значениями
            % корреляционной функции
            tmpcorr = xcorr(ReceivedBlock(:,columnIndex), PssSequence);
            corr(:, columnIndex) = abs(max(tmpcorr));
        end

        % Заполняем массивы максимальных изначений КФ и их индексов. Они
        % получены для каждого NID2
        [peak_value(NID2+1), peak_index(NID2+1)] = max(corr);
    end
    
    % Определяем NID2
    NID2 = find(peak_value==max(peak_value)) - 1;
    % Возвращаем номер слота, в котором находится PSS
    PSSTimeSlotIndex = peak_index(NID2+1);
end