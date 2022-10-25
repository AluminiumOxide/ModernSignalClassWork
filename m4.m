clear
clc
close all

load 119.mat

size_M = size(M_00);
from = 360*300+360*120*10+1;
to = from+360*30-1;
M_list = {M_24,M_18,M_12,M_06,M_00,M__6};
clearvars M_24 M_18 M_12 M_06 M_00 M__6
M_pure = M_inf(from:to,2);
M_cut = M_list{3}(from:to,2);

%% 开始
dwtmode('per','nodisplay');
% 'db4' 'db6' 'sym6';
wname = 'db4';
level = 3;
[C, L] = wavedec(M_cut,level,wname);
TIME = 1/360:1/360:10;

%取第5层低频近似系数
ca5=appcoef(C,L,wname,level);
%取各层高频细节系数
cd1=detcoef(C,L,1);
cd2=detcoef(C,L,2);
cd3=detcoef(C,L,3);
% cd4=detcoef(C,L,4);
% cd5=detcoef(C,L,5);

thr=thselect(M_cut,'sqtwolog');   % 不知道这个合不合适
% 获取各级阈值
thr1=thselect(cd1,'rigrsure');
thr2=thselect(cd2,'rigrsure');
thr3=thselect(cd3,'rigrsure');
% thr4=thselect(cd4,'rigrsure');
% thr5=thselect(cd5,'rigrsure');
% 进行软阈值处理
ysoft1=wthresh(cd1,'s',thr1);
ysoft2=wthresh(cd2,'s',thr2);
ysoft3=wthresh(cd3,'s',thr3);
% ysoft4=wthresh(cd4,'s',thr4);
% ysoft5=wthresh(cd5,'s',thr5);

% ysoft1=wthresh(cd1,'s',thr);
% ysoft2=wthresh(cd2,'s',thr);
% ysoft3=wthresh(cd3,'s',thr);
% ysoft4=wthresh(cd4,'s',thr);
% ysoft5=wthresh(cd5,'s',thr);
% 拼接
c1=[ca5;ysoft3;ysoft2;ysoft1];
% c1=[ca5;ysoft5;ysoft4;ysoft3;ysoft2;ysoft1];


M_rec=waverec(c1,L,wname);


figure();
subplot(3,1,1)
plot(M_pure,'-',LineWidth=1.5);
title('Original singal')
% legend('detail info (original)')
grid on

subplot(3,1,2)
plot(M_cut,'-',LineWidth=1.5);
title('Noise singal')
% legend('detail info (original) %')
grid on

subplot(3,1,3)
plot(M_rec,'-',LineWidth=1.5);
title('Reconstruct singal')
% legend('detail info (original)')
grid on
% grid minor
normalize(M_pure);
normalize(M_cut);
normalize(M_rec);
psnr(normalize(M_cut),normalize(M_pure))
psnr(normalize(M_rec),normalize(M_pure))