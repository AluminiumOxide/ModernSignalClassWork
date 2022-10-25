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
flag = 1;
% 拼接650000 14
M_mix = [M_inf M_24 M_18 M_12 M_06 M_00 M__6];
M_name = {'Original','24db','18db','12db','6db','0db','-6db'};
figure()
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


    subplot(6,1,flag)
    plot(Timecut,Mpure(:,1),LineWidth=1.5)
    hold on 
    plot(Timecut,M_6db(:,1),LineWidth=1.5)
    hold on 
    plot(Timecut,M_6db(:,1)+bias(6,1),LineWidth=1.5)
    grid on
    change = mean(M_6db(:,1)+bias(6,1));
    disp(['org ',num2str(means(1,1)),' noise',num2str(means(7,1)),'changed ',num2str(change)])
flag = flag+1;

end
xlabel('Time s',FontSize=16)
legend({'Pure','Noise','De-offset'},Location="southwest",FontSize=12)
% legend({'a','b','c'},Location="southwest",FontSize=16)


