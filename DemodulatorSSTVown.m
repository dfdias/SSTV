% Desmodulacao de um sinal SSTV na componente que codifica a intensidade
% das linhas na frequencia

clear; clc

[x,Fa]= audioread('f.wav');
x = x(:,1);
Ta= 1/Fa;
% Determina o numero de amostras para analise em frequ?ncia
Na= round(0.03*Fa);

% Projeto dos filtros do codigo VIS
B= 100;
f= [1100 1200 1300 1500 1900];
h= zeros(Na+1,4);
for k= 1:5,
    F= [0 f(k)-B  f(k)-B/2 f(k)+B/2  f(k)+B Fa/2]/(Fa/2);
    M= [0 0 1 1 0 0];
    W= [10 1 10];
    h(:,k)= firpm(Na,F,M,W);
    H(:,k)= freqz(h(:,k),1,1024,Fa);
end
% Mostra os 3 filtros
figure(1)
fk= (0:1023)*Fa/2048;
plot(fk,20*log10(abs(H)))
title('Resposta em frequencia dos filtros')

y= fftfilt(h,x);

% Detetor de envolvente
hl= fir1(Na,0.01);
e= filter(hl,1,y.*y);
figure(2) 
t= (0:length(e)-1)*Ta*1000;
plot(t,e(:,[2 4]))
xlabel('ms')
title('Saida dos detetores de envolvente')
legend('1100Hz','1200Hz','1300Hz','1900Hz')

% Espectrograma de uma linha

figure(3)
im = [0]
Nfft= 32;
ini= 40000
%spectrogram(x(ini:(ini+1614+32)),32,26,2048,Fa,'yaxis');

%pcolor(ans)

% Calcula o maximo de cada DFT para obter o nivel de cinza
%[dum,I]= max(S);

%figure(4)
%stem(I)

% Cada linha tem cerca de 1614 amosrtras do sinal e um pixel dura cerca de
% 6 amostras. Como se usou uma DFT de 128 amostras vamos ter 65 n?veis de
% cinza.
nfft = 128;
fvals = (Fa*(0:(nfft/2)-1)/nfft);
tpixel = 572e-6
pixelsample = round(tpixel/Ta)
tsync = 4862e-6
tsyncsample = round(tsync/Ta)

pix = 1 : 1 : 257;
fftx = fft(x(ini:ini+25),nfft)

