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
indexLine = 2;

% eva_snr_org = ones(6,6);
% eva_snr_out = ones(6,6);
for indexTime = 1:6
    M_cut = deoffset{indexTime};

    M_pure = M_cut{8}(:,indexLine);
    timelist = M_cut{7};
    % 内层循环是去遍历24、18、12、6、0、-6、
    for indexNoise = 1:6

        M_Noise = M_cut{indexNoise}(:,indexLine);
        M_output = wden(M_Noise,'rigrsure','s','sln',level,wname);
        % 计算损失
        SNR_Noise = snr(M_pure,M_Noise);
        SNR_Output = snr(M_pure,M_output);
        PSNR_Noise = psnr(M_pure,M_Noise);
        PSNR_Output = psnr(M_pure,M_output);
        SSIM_Noise = ssim(M_pure,M_Noise);
        SSIM_Output = ssim(M_pure,M_output);
        % 
        eva_snr_org(indexTime,indexNoise)=SNR_Noise;
        eva_psnr_org(indexTime,indexNoise)=PSNR_Noise;
        eva_ssim_org(indexTime,indexNoise)=SSIM_Noise;

        eva_snr_out(indexTime,indexNoise)=SNR_Output;
        eva_psnr_out(indexTime,indexNoise)=PSNR_Output;
        eva_ssim_out(indexTime,indexNoise)=SSIM_Output;

    end
    
%     break
end
eva_snr_org_mean = mean(eva_snr_org);
eva_snr_out_mean = mean(eva_snr_out);
eva_psnr_org_mean = mean(eva_psnr_org);
eva_psnr_out_mean = mean(eva_psnr_out);
eva_ssim_org_mean = mean(eva_ssim_org);
eva_ssim_out_mean = mean(eva_ssim_out);

eva_mean_collect = [eva_snr_org_mean;eva_snr_out_mean;
    eva_psnr_org_mean;eva_psnr_out_mean;
    eva_ssim_org_mean;eva_ssim_out_mean;]

eva_mean_res = [eva_snr_out_mean-eva_snr_org_mean;
    eva_psnr_out_mean-eva_psnr_org_mean;
    eva_ssim_out_mean-eva_ssim_org_mean;]
