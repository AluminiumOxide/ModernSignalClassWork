clear
clc
close all

load 118.mat

size_M = size(M_00);
second = 10;
from = 360*300+360*120*10+1;  to = from+360*second-1;  TIME = 1/360:1/360:second;
M_list = {M_24,M_18,M_12,M_06,M_00,M__6};
clearvars M_24 M_18 M_12 M_06 M_00 M__6
M_pure = M_inf(from:to,2);
% M_cut = M_list{3}(from:to,2);
% 
% %% 开始
% 
% dwtmode('per','nodisplay');
% % 'db4' 'db6' 'sym6';
% wname = 'db6';
% level = 5;
% [C, L] = wavedec(M_cut,level,wname);


figure(1);
subplot(7,1,1);
    plot(TIME,M_pure) % -20*log10(norm(abs(M_00-M_24))./norm(M_00))
    title(sprintf('Original signal' ));
    grid on

for i =1:6
    
    M_cut = M_list{i}(from:to,2);
%     M_pure = M_list{5}(1:from,2);
%     M_cut = M_list{i}(1:from,2);
    num = i*2-1;
    subplot(7,1,i+1);
    plot(TIME,M_cut) % -20*log10(norm(abs(M_00-M_24))./norm(M_00))
    title(sprintf('Signal noise ratio:  %0.4f dB',snr(M_pure,M_cut) ));
    grid on
%     disp(-20*log10(norm(abs(M_pure-M_cut))/norm(M_pure)));
    disp(['org ',int2str(i),'is:',num2str(snr(M_pure,M_cut)),'  ', ...
        num2str(ssim(M_cut,M_pure)),'  ', ...
        num2str(psnr(M_cut,M_pure))]);

%     subplot(6,2,num+1);
%     M_fd = wden(M_cut,'rigrsure','s','sln',level,wname);
%     plot(M_fd)
%     title(sprintf('Moving Average SNR:  %0.4f dB',snr(M_pure,M_fd) ));
% 
%     disp(['dwt ',int2str(i),'is:',num2str(snr(M_pure,M_fd)),'  ', ...
%         num2str(ssim(M_cut,M_fd)),'  ', ...
%         num2str(psnr(M_cut,M_fd))]);
end

% xlabel('Time (s)')
% figure();
% subplot(2,2,num+1);
% M_fd = wden(M_cut,'rigrsure','s','sln',level,wname);
% plot(M_fd)
% title(sprintf('Moving Average SNR:  %0.4f dB',snr(M_pure,M_fd) ));
% 
% disp(['dwt ',int2str(i),'is:',num2str(snr(M_pure,M_fd)),'  ', ...
%     num2str(ssim(M_cut,M_fd)),'  ', ...
%     num2str(psnr(M_cut,M_fd))]);



% %取第5层低频近似系数
% ca5=appcoef(C,L,wname,level);
% %取各层高频细节系数
% cd1=detcoef(C,L,1);
% cd2=detcoef(C,L,2);
% cd3=detcoef(C,L,3);
% cd4=detcoef(C,L,4);
% cd5=detcoef(C,L,5);
% 
% thr=thselect(M_cut,'sqtwolog');   % 不知道这个合不合适
% % 获取各级阈值
% thr1=thselect(cd1,'rigrsure');
% thr2=thselect(cd2,'rigrsure');
% thr3=thselect(cd3,'rigrsure');
% thr4=thselect(cd4,'rigrsure');
% thr5=thselect(cd5,'rigrsure');
% % 进行软阈值处理
% ysoft1=wthresh(cd1,'s',thr1);
% ysoft2=wthresh(cd2,'s',thr2);
% ysoft3=wthresh(cd3,'s',thr3);
% ysoft4=wthresh(cd4,'s',thr4);
% ysoft5=wthresh(cd5,'s',thr5);
% 
% % ysoft1=wthresh(cd1,'s',thr);
% % ysoft2=wthresh(cd2,'s',thr);
% % ysoft3=wthresh(cd3,'s',thr);
% % ysoft4=wthresh(cd4,'s',thr);
% % ysoft5=wthresh(cd5,'s',thr);
% % 拼接
% % c1=[ca5;ysoft3;ysoft2;ysoft1];
% c1=[ca5;ysoft5;ysoft4;ysoft3;ysoft2;ysoft1];
% 
% 
% M_rec=waverec(c1,L,wname);
% 
% 
% figure();
% subplot(3,1,1)
% plot(M_pure,'-',LineWidth=1.5);
% title('Original singal')
% % legend('detail info (original)')
% grid on
% 
% subplot(3,1,2)
% plot(M_cut,'-',LineWidth=1.5);
% title('Noise singal')
% % legend('detail info (original)')
% grid on
% 
% subplot(3,1,3)
% plot(M_rec,'-',LineWidth=1.5);
% title('Reconstruct singal')
% % legend('detail info (original)')
% grid on
% % grid minor

