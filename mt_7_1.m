clear
clc
close all

load _noise.mat

mixSignal = M_118+0.1*M_bw+0.1*M_em+0.1*M_ma+0.1*randn(size(M_118));
jgaus = imnoise(M_118,'gaussian');
jpois = imnoise(M_118,'poisson');
jsalt = imnoise(M_118,'salt & pepper');
Jspec = imnoise(M_118,'speckle');

mix118 = mixSignal(1:3600,:)
wname = 'sym6';
level =12;
indexLine = 1;
M_pure = M_118(1:3600,indexLine);
M_Noise = mix118(:,indexLine);
M_output1 = wden(M_Noise,'rigrsure','s','sln',level,wname);
psnr(M_Noise,M_pure)
psnr(M_output1,M_pure)

figure()
subplot(311)
plot(M_pure)
subplot(312)
plot(M_Noise)
subplot(313)
plot(M_output1)