%modulator
%Duarte Dias
%DETI-UA
%2016
clear all
clc
fs = 48000;
file = imread('image.jpg');

[space300,space30,spacebreak,pixeltime_samples,colorsync_samples,syncporch_samples,vlsihi,vlsilo,colorfreq,colorsyncpulse,linevector] = structData(file,fs);

%starting signal generator
%let's generate the image signal first and then the VLSI code

porchsignal = sin(2*pi*1500*syncporch_samples);
colorsignal = zeros(length(colorfreq),length(pixeltime_samples));
for k = 1 : length(colorfreq)
    colorsignal(k,:) = sin(2*pi*colorfreq(k)*pixeltime_samples);
end;
    tic;
signal = zeros(1,2);
signal = [signal sin(2*pi*colorsyncpulse*syncporch_samples)];
for k= 1: length(linevector)
    val = linevector(k);
    %if (val == 500)
     %  signal = [signal porchsignal];
      % k = k+1;
     %end;
    %if (val == 1000)
     % signal = [signal porchsignal];
      %k = k+1;

   signal = [signal colorsignal(val+1,:)];
  
    rem = length(linevector)-1
end;
toc;
signal = signal(2:end); %%cuting the first two zeros

dur = length(signal)/fs
% generating VLSI code
        

 wavwrite(signal,fs,32,'generated');
 
