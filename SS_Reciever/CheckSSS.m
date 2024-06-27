function NID1 = CheckSSS(ReceivedBlock, NID2, PSSTimeSlotIndex)
    % Массив, в который будет сохраняться результат вычисления КФ для
    % каждой SSS последовательности 
    corr = zeros(1, 336);
    for NID1 = 0:335
        % находим подходящее значение NID1 подбором
        % вычисляем NcellId для каждого значения NID1
        ncellid = 3*NID1 + NID2;
        % Получаем последовательность SSS для определенного индекса ncellid
        SssSequence = fft(SssGenerator.generateSssByCellInfo(ncellid));
      
        % Вычисляем корреляционную функцию и сохраняем сумму в массив
        corr(NID1+1) = abs(max(xcorr(ReceivedBlock(:, PSSTimeSlotIndex+2), SssSequence)));
    end
    % находим максимальное значение
    [peak_value, peak_index] = max(corr);
    % Определяем NID1
    NID1 = peak_index-1;
end