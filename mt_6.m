clear
clc
close all
load 118.mat

% 截取时间断点
FullTime = 1/360:1/360:650000/360;
TimeBP = [360*300+1];  % Timebreakpoint
for i=1:11
    TimeBP(i+1) = 360*300 + 360*120*i;
end
TimeBP(i+2) = 650000;


% 拼接650000 14
M_mix = [M_inf M_24 M_18 M_12 M_06 M_00 M__6];
M_name = {'Original','24db','18db','12db','6db','0db','-6db'};
collect = {};
flag = 1;
for i=1:2:11
    Timecut = FullTime(TimeBP(i):TimeBP(i+1));
    % 每个cut里面都包含该段混叠和原时间，但是需要均值才能方便后续计算
    M_cut = M_mix(TimeBP(i):TimeBP(i+1),:);
    Mpure = M_cut(:,1:2);
    M24db = M_cut(:,3:4);
    M18db = M_cut(:,5:6);
    M12db = M_cut(:,7:8);
    M06db = M_cut(:,9:10);
    M00db = M_cut(:,11:12);
    M_6db = M_cut(:,13:14);
    means = [mean(Mpure,1);mean(M24db,1);mean(M18db,1);mean(M12db,1);mean(M06db,1);mean(M00db,1);mean(M_6db,1)];
    bias = [means(1,:)-means(2,:);  % 24
means(1,:)-means(3,:);
means(1,:)-means(4,:);
means(1,:)-means(5,:);  % 6
means(1,:)-means(6,:);
means(1,:)-means(7,:);];  % -6
%     deoffset 里对应着当前这个时间段里调整偏移的数据
    deoffset24 = M24db(:,:)+bias(1,:);
    deoffset18 = M18db(:,:)+bias(2,:);
    deoffset12 = M12db(:,:)+bias(3,:);
    deoffset06 = M06db(:,:)+bias(4,:);
    deoffset00 = M00db(:,:)+bias(5,:);
    deoffset_6 = M_6db(:,:)+bias(6,:);
    deoffset{flag} = {deoffset24,deoffset18,deoffset12,deoffset06,deoffset00,deoffset_6,Timecut',Mpure};

flag = flag+1;
end
%% ---------------------------------------------------------------
% 隔得久了，数太多忘了，留个有用的得了
save changeOffset.mat deoffset;
clearvars
load changeOffset.mat
% 这里重新开始循环，deoffset是包含6个时间段的元胞数组
% 每个时间段内都有7个数组，分别是:24、18、12、6、0、-6、时间戳、原数据
% 'db4' 'db6' 'sym6' 'bior6.8' 'rbio6.8';
wname = 'bior6.8';
level =11;
indexLine = 1;

% eva_snr_org = ones(6,6);
% eva_snr_out = ones(6,6);
for indexTime = 1:6
    M_cut = deoffset{indexTime};

    M_pure = M_cut{8}(:,indexLine);
    timelist = M_cut{7};
    % 内层循环是去遍历24、18、12、6、0、-6、
    for indexNoise = 1:6

        M_Noise = M_cut{indexNoise}(:,indexLine);
        M_output1 = wden(M_Noise,'rigrsure','s','sln',level,wname);
        M_output2 = sgolayfilt(M_Noise,31,101);
        M_output3 = filtfilt(1/20*ones(20,1),1,M_Noise);
        % 计算损失
        SNR_Noise = snr(M_pure,M_Noise);
        SNR_Output1 = snr(M_pure,M_output1);
        SNR_Output2 = snr(M_pure,M_output2);
        SNR_Output3 = snr(M_pure,M_output3);
        PSNR_Noise = psnr(M_pure,M_Noise);
        PSNR_Output1 = psnr(M_pure,M_output1);
        PSNR_Output2 = psnr(M_pure,M_output2);
        PSNR_Output3 = psnr(M_pure,M_output3);
        SSIM_Noise = ssim(M_pure,M_Noise);
        SSIM_Output1 = ssim(M_pure,M_output1);
        SSIM_Output2 = ssim(M_pure,M_output2);
        SSIM_Output3 = ssim(M_pure,M_output3);
        % 
        eva_snr_org(indexTime,indexNoise)=SNR_Noise;
        eva_psnr_org(indexTime,indexNoise)=PSNR_Noise;
        eva_ssim_org(indexTime,indexNoise)=SSIM_Noise;

        eva_snr_out1(indexTime,indexNoise)=SNR_Output1;
        eva_snr_out2(indexTime,indexNoise)=SNR_Output2;
        eva_snr_out3(indexTime,indexNoise)=SNR_Output3;
        eva_psnr_out1(indexTime,indexNoise)=PSNR_Output1;
        eva_psnr_out2(indexTime,indexNoise)=PSNR_Output2;
        eva_psnr_out3(indexTime,indexNoise)=PSNR_Output3;
        eva_ssim_out1(indexTime,indexNoise)=SSIM_Output1;
        eva_ssim_out2(indexTime,indexNoise)=SSIM_Output2;
        eva_ssim_out3(indexTime,indexNoise)=SSIM_Output3;

    end
    
%     break
end
eva_snr_org_mean = mean(eva_snr_org);
eva_snr_out1_mean = mean(eva_snr_out1);
eva_snr_out2_mean = mean(eva_snr_out2);
eva_snr_out3_mean = mean(eva_snr_out3);
eva_psnr_org_mean = mean(eva_psnr_org);
eva_psnr_out1_mean = mean(eva_psnr_out1);
eva_psnr_out2_mean = mean(eva_psnr_out2);
eva_psnr_out3_mean = mean(eva_psnr_out3);
eva_ssim_org_mean = mean(eva_ssim_org);
eva_ssim_out1_mean = mean(eva_ssim_out1);
eva_ssim_out2_mean = mean(eva_ssim_out2);
eva_ssim_out3_mean = mean(eva_ssim_out3);

eva_mean_collect = [
    eva_snr_org_mean; eva_snr_out1_mean; eva_snr_out2_mean; eva_snr_out3_mean;
    eva_psnr_org_mean;eva_psnr_out1_mean;eva_psnr_out2_mean;eva_psnr_out3_mean;
    eva_ssim_org_mean;eva_ssim_out1_mean;eva_ssim_out2_mean;eva_ssim_out3_mean;]

types = {'Original','Wavelet','Savitzky Golay','Moving Average'};
types = {'Wavelet','Savitzky Golay','Moving Average'};
draw_x = 24:-6:-6;
figure()
subplot(3,1,1)
draw_snr = eva_mean_collect(2:4,:)';
b = bar(draw_snr,LineWidth=1.5,EdgeColor="none");
legend(types,Location="southwest")
b(3).FaceColor = [.2 .6 .5];
grid on
title('SNR','FontSize',16)
% xticklabels({'e24db','','e18db','','e12db','','e6db','','e0db','','e-6db'})
xticklabels({'e24db','e18db','e12db','e6db','e0db','e-6db'})

subplot(3,1,2)
draw_psnr = eva_mean_collect(6:8,:)';
b = bar(draw_psnr,LineWidth=1.5,EdgeColor="none");
b(3).FaceColor = [.2 .6 .5];
legend(types)
grid on
title('PSNR','FontSize',16)
xticklabels({'e24db','e18db','e12db','e6db','e0db','e-6db'})

subplot(3,1,3)
draw_ssim = eva_mean_collect(10:12,:)';
b = bar(draw_ssim,LineWidth=1.5,EdgeColor="none");
b(3).FaceColor = [.2 .6 .5];
legend(types)
grid on
title('SSIM','FontSize',16)
xticklabels({'e24db','e18db','e12db','e6db','e0db','e-6db'})

