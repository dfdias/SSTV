 clear; clc

[x,Fa]= audioread('m.wav');
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
plot(t,e(:,[1 3 5]))
xlabel('ms')
title('Saida dos detetores de envolvente');
legend('1100Hz','1300Hz','1900Hz');


% signal sturattion

one = e(:,3) >= 0.23;
e(one,3) = 0.23;
one = e(:,3);

zero = e(:,1) >= 0.2; %saturation at a determinate level 
e(zero,1) = 0.2;
zero = e(:,1);

idxone = find(one == 0.23)

idxzero = find(zero == 0.2);

viscode = zeros(1,9)


%finding viscode bit levels
















