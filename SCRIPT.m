clc
clear all

file = wavread('sunset.wav');

fs = 11025;
imagedata = struct('')
timejumps = struct('')

timejumps(1).vlsileader = 0.3;
timejumps(1).vlsibit = 0.030;
timejumps(1).vlsibreak = 0.010;
timejumps(2).samplejump300 = round(timejumps(1).vlsileader * fs);
timejumps(2).samplejump30 = round(timejumps(1).vlsibit * fs);
timejumps(2).samplejumpbreak = round(timejumps(1).vlsibreak * fs);



imagedata(1).R = zeros(360,256);
imagedata(1).G = zeros(360,256);
imagedata(1).B = zeros(360,256);
imagedata(1).image(:,:,1) = imagedata(1).R;
imagedata(1).image(:,:,2) = imagedata(1).G;
imagedata(1).image(:,:,3) = imagedata(1).B;



%spectrogram(file,128,120,128,fs,'yaxis')
dur = length(file)*1/fs
nfft = 100000;
fvals = round(fs*(0:(nfft/2)-1)/nfft);

fftx = fft(file,nfft);
fftx = fftx(1:nfft/2);

plot(fvals,abs(fftx))
title('Espectro de Frequência do Sinal Amplificado')
xlabel('Frequência (Hz)')
ylabel('Magnitude')

f2save = 1100:1:2300;
fftx2 = zeros(1,4999);

for k = 1 : length(f2save)
      idx = find(fvals == f2save(k));
      fftx2(idx) = fftx(idx);
end

filtered = ifft(fftx2,nfft);
filtered = filtered(0.12*fs : end);


axis([0 0.12 0 3000]);
fvals = (fs*(0:(nfft/2)-1)/nfft);

analysis = filtered(1:timejumps(2).samplejump300)



analysis = analysis(1:timejumps(2).samplejumpbreak)

fftfilt = fft(analysis,nfft);
fftfilt = fftfilt(1:nfft/2);
figure(2)
plot(fvals,abs(fftfilt))

freq = find(fftfilt == max(fftfilt))

figure(3)
t = 0 : 1 :timejumps(2).samplejumpbreak-1;
plot(t,analysis);
fvals(freq)
