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
mix118 = M_118+NoiseSingle;
mix119 = M_119+NoiseSingle;
%% 混叠完数据开始
timeto = 360*300;
% 绘图用的
M_name = {'SNR','PSNR','SSIM'};
TimeSample = 1/360:1/360:10;
figure
for indexLine = 1:2
    Cutmix118 = mix118(1:timeto,indexLine); % 切片
    Cutmix119 = mix119(1:timeto,indexLine);
    CutOrg118 = M_118(1:timeto,indexLine);  % 页对应着原信息切片
    CutOrg119 = M_119(1:timeto,indexLine);
    % 小波的参数
    wname = 'bior6.8';
    level =12;
    % 滤波
    CutOut118 = wden(Cutmix118,'rigrsure','s','sln',level,wname);
    CutOut119 = wden(Cutmix119,'rigrsure','s','sln',level,wname);


    % 画图 评价指标 一共两行 

    % 118的 ------------------------------
    subplot(2,4,(indexLine-1)*4+1) % 1
    plot(TimeSample,Cutmix118(3601:7200))  % 两条线
    hold on
    plot(TimeSample,CutOut118(3601:7200))
    grid on
    ylabel(sprintf('channel %d',indexLine))
    xlabel("time S")
    title('118 cut single')
    legend({'Noise','Wavelet'},Location="northeast")

    subplot(2,4,(indexLine-1)*4+2) % 1
    CutEva118 = [ snr(Cutmix118,CutOrg118), snr(CutOut118,CutOrg118);
                 psnr(Cutmix118,CutOrg118),psnr(CutOut118,CutOrg118);
                 ssim(Cutmix118,CutOrg118),ssim(CutOut118,CutOrg118);];
    b = bar(CutEva118,LineWidth=1.5,EdgeColor="none");  % 几组评价指标 6个数
        xtips1 = b(1).XEndPoints;
        ytips1 = b(1).YEndPoints;
%         labels1 = string(b(1).YData);
        labels1 = string([round(b(1).YData(1),4), ...
                          round(b(1).YData(2),4),...
                          round(b(1).YData(3),4)]);   
        text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')
        xtips2 = b(2).XEndPoints;
        ytips2 = b(2).YEndPoints;
        ytips2(1) = ytips2(1)+1;
        ytips2(3) = ytips2(3)+0.5;
        labels2 = string([round(b(2).YData(1),4), ...
                          round(b(2).YData(2),4),...
                          round(b(2).YData(3),4)]);   
%         labels2 = string([sprintf('%0.4f',b(2).YData(1)), ...
%             sprintf('%0.4f',b(2).YData(2)),...
%             sprintf('%0.4f',b(2).YData(3))]);
        text(xtips2,ytips2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom')
    xlabel('evaluate type')
    grid on
    title('118 total evaluate')
    legend({'Noise','Wavelet'},Location="east")
    xticklabels(M_name)


    % 119的 ------------------------------
    subplot(2,4,(indexLine-1)*4+3) % 1
    plot(TimeSample,Cutmix119(3601:7200))  % 两条线
    hold on
    plot(TimeSample,CutOut119(3601:7200)) 
    grid on
    title('119 cut single')
    xlabel("time S")
    legend({'Noise','Wavelet'},Location="northeast")


    subplot(2,4,(indexLine-1)*4+4) % 1
    CutEva119 = [ snr(Cutmix118,CutOrg118), snr(CutOut118,CutOrg118);
                 psnr(Cutmix118,CutOrg118),psnr(CutOut118,CutOrg118);
                 ssim(Cutmix118,CutOrg118),ssim(CutOut118,CutOrg118);];

    b = bar(CutEva119,LineWidth=1.5,EdgeColor="none");  % 几组评价指标 6个数
        xtips1 = b(1).XEndPoints;
        ytips1 = b(1).YEndPoints;
%         labels1 = string(b(1).YData);
        labels1 = string([round(b(1).YData(1),4), ...
                          round(b(1).YData(2),4),...
                          round(b(1).YData(3),4)]);   
        text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')
        xtips2 = b(2).XEndPoints;
        ytips2 = b(2).YEndPoints;
        ytips2(1) = ytips2(1)+1;
        ytips2(3) = ytips2(3)+0.5;
        labels2 = string([round(b(2).YData(1),4), ...
                          round(b(2).YData(2),4),...
                          round(b(2).YData(3),4)]);   
        text(xtips2,ytips2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom')
    xlabel('evaluate type')
    grid on
    title('118 total evaluate')
    legend({'Noise','Wavelet'},Location="east")
    xticklabels(M_name)
% 
% break
end


psnr(Cutmix118,CutOrg118)
psnr(CutOut118,CutOrg118)
% figure()
% subplot(311)
% plot(CutOrg118(1:360))
% subplot(312)
% plot(Cutmix(1:360))
% subplot(313)
% plot(CutOut118(1:360))