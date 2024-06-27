% Display spectrogram of received waveform
figure;
nfft = 256;
signal = ones(nfft, nfft);
rows = 1:2:nfft;
signal(rows, :) = 0;
rxWaveform = fft(signal);
sampleRate = 10000;
spectrogram(rxWaveform(:,1),ones(nfft,1),0,nfft,'centered',sampleRate,'yaxis','MinThreshold',-130);
title('Spectrogram of the Received Waveform')