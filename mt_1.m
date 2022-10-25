clear
clc
close all
%% 前10 min
load 118.mat
second = 1800;
from = 1;  to = 360*second;  TIME = 1/360:1/360:second;
M_list = {M_inf,M_24,M_18,M_12,M_06,M_00,M__6};
M_name_list = {'Original','24 db','18 db','12 db','6 db','0 db','-6 db'};
figure()
subplot(2,1,1)
for i=1:7
    M_cut = M_list{i}(from:to,1);
    h = plot(TIME,M_cut,'--',LineWidth=1.5); axis tight; grid on;
%     alpha(h,0.4)
    hold on
end
xlabel('Time s',FontSize=16)
ylabel('Voltage mv',FontSize=16)
legend(M_name_list,Location="southwest",FontSize=16)
title('MIT-BIH Arrhythmia VS Noise Stress Test Database',FontSize=16)

subplot(2,1,2)
for i=1:7
    M_cut = M_list{i}(from:to,2);
    h = plot(TIME,M_cut,'--',LineWidth=1.5); axis tight; grid on;
%     alpha(h,0.4)
    hold on
end
xlabel('Time s',FontSize=16)
ylabel('Voltage mv',FontSize=16)
legend(M_name_list,Location="southwest",FontSize=16)








