function [space300,space30,spacebreak,pixeltime_samples,colorsync_samples,syncporch_samples,vlsihi,vlsilo,colorfreq,colorsyncpulse,linevector]= structData(file,fs)
ts = 1/fs;
imagedata = struct('');%structure with all imageinfo
time_constraints = struct('');%stucture that stores protocol specific the time constraints
frequency_constraints =struct('');%structure  sotring frequency constraints
%%constraints for MARTIN M1 mode
time_constraints(1).vlsileader = 300e-3;%leader tone duration => 300ms
time_constraints(1).vlsibit = 30e-3; %break  tone duration => 30ms
time_constraints(1).vlsibreak = 10e-3;%break tone duration => 10ms
time_constraints(1).samplejump300 = round(time_constraints(1).vlsileader * fs); %number ofsamples equivalent to 300ms jump
time_constraints(1).samplejump30 = round(time_constraints(1).vlsibit * fs);%number ofsamples equivalent to 30ms jump
time_constraints(1).samplejumpbreak = round(time_constraints(1).vlsibreak * fs);%number ofsamples equivalent to 10ms jump
%samplevector
time_constraints(1).space30 = 0:ts:time_constraints(1).vlsibit;%sample vector
time_constraints(1).spacebreak = 0:ts:time_constraints(1).vlsibreak;%sample vector

time_constraints(2).colorsyncpulse =4.862e-3;
time_constraints(2).pixeltime = 0.4576e-3;
time_constraints(2).syncporch = 0.572e-3;
time_constraints(2).pixel_samplenum = round(time_constraints(2).pixeltime*fs);
time_constraints(2).colorsync_samplenum = round(time_constraints(2).colorsyncpulse*fs);
time_constraints(2).syncporch_samplenum = round(time_constraints(2).syncporch*fs);

time_constraints(2).pixeltime_samples= 0 : ts : time_constraints(2).pixeltime;
time_constraints(2).colorsync_samples = 0 : ts : time_constraints(2).colorsyncpulse;
time_constraints(2).syncporch_samples = 0 : ts : time_constraints(2).syncporch;

frequency_constraints(1).vlsihi = 1300;
frequency_constraints(1).vlsilo = 1100;
frequency_constraints(1).colorfreq = linspace(1500,2300,256);
frequency_constraints(1).colorsyncpulse = 1200;

%starting image processing


imagedata(1).vector = file;

imagedata(1).R = imagedata(1).vector(:,:,1);
imagedata(1).G = imagedata(1).vector(:,:,2);
imagedata(1).B = imagedata(1).vector(:,:,3);

%to simplify tesignalgeneration lets join the first rows of each color in
%one single vector
imagedata(1).linevector = zeros(1,2);
for w = 1 : 256;
    G = imagedata(1).G(w,:);
    R = imagedata(1).R(w,:);
    B = imagedata(1).B(w,:);
    
    imagedata(1).linevector = [imagedata(1).linevector G];
    imagedata(1).linevector = [imagedata(1).linevector 500]
    imagedata(1).linevector = [imagedata(1).linevector R];
    imagedata(1).linevector = [imagedata(1).linevector 500]
    imagedata(1).linevector = [imagedata(1).linevector B];
    imagedata(1).linevector = [imagedata(1).linevector 1000]

end;

imagedata(1).linevector = imagedata(1).linevector(3:end); %resizing;

space300 = linspace(0,300e-3,300e-3*fs);
space30 = time_constraints(1).space30;
spacebreak = time_constraints(1).spacebreak;

pixeltime_samples = time_constraints(2).pixeltime_samples;
colorsync_samples = time_constraints(2).colorsync_samples;
syncporch_samples = time_constraints(2).syncporch_samples;

vlsihi = frequency_constraints(1).vlsihi;
vlsilo = frequency_constraints(1).vlsilo;
colorfreq = frequency_constraints(1).colorfreq;
colorsyncpulse = frequency_constraints(1).colorsyncpulse;

linevector = imagedata(1).linevector;

clear imagedata time_constraints frequency_constraints;
clc;