close all;
clc

% Формируем принятый блок
ReceivedBlock = zeros(240, 10);


% Генерируем PSS последовательность
PssSequence = PssGenerator.generatePssByCellInfo(2);
% Сохраняем PSS последовательность, соответствующую NID2 = 1, в 5 столбец блока от начала
ReceivedBlock(56:182, 5) = PssSequence;

% for r = 1:size(ReceivedBlock, 2)
%     corr(:, r) = xcorr(ReceivedBlock(:, r), PssSequence);
% end
% 
% plot(corr(:, 5));

[NID2, PssSlot] = CheckPSS(ReceivedBlock);

NID1 = CheckSSS(ReceivedBlock, NID2, PssSlot);