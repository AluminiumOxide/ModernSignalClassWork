clear
clc
close all

load _noise.mat


jgaus = imnoise(M_118,'gaussian');
jpois = imnoise(M_118,'poisson');
jsalt = imnoise(M_118,'salt & pepper');
Jspec = imnoise(M_118,'speckle');
NoiseSingle = 0.1*M_bw+0.1*M_em+0.1*M_ma+...
            0.5*jgaus+0.5*jpois+0.1*jsalt+0.5*Jspec+0.1*randn(size(M_118));
mixSignal = M_118+NoiseSingle;

%% 混叠完数据开始
timeto = 360*300;
indexLine = 1;
Cutmix = mixSignal(1:timeto,indexLine); % 切片
CutOrg = M_118(1:timeto,indexLine);  % 页对应着原信息切片
% 小波的参数
wname = 'bior6.8';
level =12;



CutOut = wden(Cutmix,'rigrsure','s','sln',level,wname);
psnr(Cutmix,CutOrg)
psnr(CutOut,CutOrg)

figure()
subplot(311)
plot(CutOrg(1:360))
subplot(312)
plot(Cutmix(1:360))
subplot(313)
plot(CutOut(1:360))