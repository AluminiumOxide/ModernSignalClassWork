clear
clc
close all

load 118.mat

size_M = size(M_00);
from = 360*300+360*120*10+1;
to = from+360*60-1;
M_list = {M_24,M_18,M_12,M_06,M_00,M__6};
clearvars M_24 M_18 M_12 M_06 M_00 M__6
M_pure = M_list{5}(from:to,2);
M_cut = M_list{1}(from:to,2);

%% 开始
dwtmode('per','nodisplay');
wname = 'sym6';
level = 5;
[C, L] = wavedec(M_cut,level,wname);
TIME = 1/360:1/360:10;

%取第5层低频近似系数
ca5=appcoef(C,L,'db4',5);
%取各层高频细节系数
cd1=detcoef(C,L,1);
cd2=detcoef(C,L,2);
cd3=detcoef(C,L,3);
cd4=detcoef(C,L,4);
cd5=detcoef(C,L,5);

thr=thselect(M_cut,'sqtwolog');   % 不知道这个合不合适
% 获取各级阈值
thr1=thselect(cd1,'rigrsure');
thr2=thselect(cd2,'rigrsure');
thr3=thselect(cd3,'rigrsure');
thr4=thselect(cd4,'rigrsure');
thr5=thselect(cd5,'rigrsure');
% 进行软阈值处理
ysoft1=wthresh(cd1,'s',thr1);
ysoft2=wthresh(cd2,'s',thr2);
ysoft3=wthresh(cd3,'s',thr3);
ysoft4=wthresh(cd4,'s',thr4);
ysoft5=wthresh(cd5,'s',thr5);
% 拼接
c1=[ca5;ysoft5;ysoft4;ysoft3;ysoft2;ysoft1];


thbar4 = ones(length(cd4),1)*thr4;

figure();
subplot(2,1,1)
plot(cd4,'-',LineWidth=1.5);
hold on
A1 = area(thbar4,0,EdgeColor="none",FaceColor=[0.8 0.8 0.8],PickableParts="none");
alpha(A1,0.4)
A2 = area(-thbar4,0,EdgeColor="none",FaceColor=[0.8 0.8 0.8],PickableParts="none");
alpha(A2,0.4)
xlim([0,225])
title('Details info before truncate')
legend('detail info (original)')
grid on
% grid minor

subplot(2,1,2)
plot(ysoft4,'-',LineWidth=1.5)
xlim([0,225])
title('Details info after truncate')
legend('detail info (denoised)')
grid on
% grid minor
% xlabel("Time (Seconds)")
% ylabel("Frequency (Hz)")