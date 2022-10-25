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


save changeOffset.mat deoffset;
clearvars
load changeOffset.mat
% 这里重新开始循环，deoffset是包含6个时间段的元胞数组
% 每个时间段内都有7个数组，分别是:24、18、12、6、0、-6、时间戳、原数据

indexLine = 1;
for indexTime = 1:6
    M_cut = deoffset{indexTime};

    M_pure = M_cut{8}(:,indexLine);
    timelist = M_cut{7};
%     M_24_1 = M_cut{1}(:,indexLine);
    figure()
    
    for indexNoise = 1:1
        M_Noise = M_cut{indexNoise}(:,indexLine);
        plot(M_Noise)
        hold on
    end
    plot(M_pure)
    break
end


