% This programm reads ECG data which are saved in format 212.
% (e.g., 100.dat from MIT-BIH-DB, cu01.dat from CU-DB,...)
% The data are displayed in a figure together with the annotations.
% The annotations are saved in the vector ANNOT, the corresponding
% times (in seconds) are saved in the vector ATRTIME.
% The annotations are saved as numbers, the meaning of the numbers can
% be found in the codetable "ecgcodes.h" available at www.physionet.org.
%
% ANNOT only contains the most important information, which is displayed
% with the program rdann (available on www.physionet.org) in the 3rd row.
% The 4th to 6th row are not saved in ANNOT.
%
%
%      created on Feb. 27, 2003 by
%      Robert Tratnig (Vorarlberg University of Applied Sciences)
%      (email: rtratnig@gmx.at),
%
%      algorithm is based on a program written by
%      Klaus Rheinberger (University of Innsbruck)
%      (email: klaus.rheinberger@uibk.ac.at)
%
% -------------------------------------------------------------------------
clc; clear all;
close all

%------ SPECIFY DATA ------------------------------------------------------
num = '233';
PATH= '../dataset/database1'; % path, where data are saved
HEADERFILE= [num,'.hea'];      % header-file in text format
ATRFILE= [num,'.atr'];         % attributes-file in binary format
DATAFILE= [num,'.dat'];         % data-file
SAMPLES2READ=2000;         % number of samples to be read
                            % in case of more than one signal:
                            % 2*SAMPLES2READ samples are read

%------ LOAD HEADER DATA --------------------------------------------------
fprintf(1,'\\n$> WORKING ON %s ...\n', HEADERFILE);  % 这部分相当于在处理hea文件
signalh= fullfile(PATH, HEADERFILE);
fid1=fopen(signalh,'r');
z= fgetl(fid1);  % fgetl 读取文件中的行，并删除换行符  文件名、导联数、采样率、数据点数
A= sscanf(z, '%*s %d %d %d',[1,3]);
nosig= A(1);  % 导联数
sfreq=A(2);   % 采样率
clear A;
for k=1:nosig
    z= fgetl(fid1);
    A= sscanf(z, '%*s %d %d %d %d %d',[1,5]);
    dformat(k)= A(1);           % format; here only 212 is allowed
    gain(k)= A(2);              % number of integers per mV  200
    bitres(k)= A(3);            % bitresolution  11
    zerovalue(k)= A(4);         % integer value of ECG zero point  1024
    firstvalue(k)= A(5);        % first integer value of signal (to test for errors)
end;
fclose(fid1);
clear A;

%------ LOAD BINARY DATA --------------------------------------------------
% 这里只是按照二进制正常读文件，2*12bit的
if dformat~= [212,212], error('this script does not apply binary formats different to 212.'); end;
signald= fullfile(PATH, DATAFILE);            % data in format 212
fid2=fopen(signald,'r');
A= fread(fid2, [3, SAMPLES2READ], 'uint8')';  % matrix with 3 rows, each 8 bits long, = 2*12bit
fclose(fid2);
% 关于将8位数据恢复成12位
M2H= bitshift(A(:,2), -4);  % 第二列右移4位(不是循环)(高4)
M1H= bitand(A(:,2), 15);  % 第二列把低4位留下？(低4)
PRL=bitshift(bitand(A(:,2),8),9);     % sign-bit 
PRR=bitshift(bitand(A(:,2),128),5);   % sign-bit
M( : , 1)= bitshift(M1H,8)+ A(:,1)-PRL;  % 相当于把第二列高四位 拼到 第一列 前面
M( : , 2)= bitshift(M2H,8)+ A(:,3)-PRR;  % 相当于把第二列低四位 拼到 第三列 前面
% 这里是验证，可以略
if M(1,:) ~= firstvalue, error('inconsistency in the first bit values'); end;

switch nosig
    case 2  % 根据前面设定裁剪多少点的参数裁剪 这部分就看成还在处理数据(单位方面的)
    % (采样值-1024)/200 (采样值-零点值)/每mv的分辨率
    M( : , 1)= (M( : , 1)- zerovalue(1))/gain(1); 
    M( : , 2)= (M( : , 2)- zerovalue(2))/gain(2);
    % 这里M储存的值为心电对应的电压值(mv)
    TIME=(0:(SAMPLES2READ-1))/sfreq;
    % 计算采样用时(每点对应的时间)
case 1
    M( : , 1)= (M( : , 1)- zerovalue(1));
    M( : , 2)= (M( : , 2)- zerovalue(1));
    M=M';
    M(1)=[];
    sM=size(M);
    sM=sM(2)+1;
    M(sM)=0;
    M=M';
    M=M/gain(1);
    TIME=(0:2*(SAMPLES2READ)-1)/sfreq;
otherwise  % this case did not appear up to now!
    % here M has to be sorted!!!
    disp('Sorting algorithm for more than 2 signals not programmed yet!');
end;
clear A M1H M2H PRR PRL;
fprintf(1,'\\n$> LOADING DATA FINISHED \n');

%------ LOAD ATTRIBUTES DATA ----------------------------------------------
% 处理注释信息，可以认为是那个R标记
atrd= fullfile(PATH, ATRFILE);      % attribute file with annotation data
fid3=fopen(atrd,'r');
A= fread(fid3, [2, inf], 'uint8')';
fclose(fid3);
ATRTIME=[];
ANNOT=[];
sa=size(A);  % 2279，2
saa=sa(1);
i=1;
while i<=saa
    % 注释文件
    annoth=bitshift(A(i,2),-2);  % 右移2 剩下高6位  这里得回文档对表！一会放到ANNOT里
    
    if annoth==59
        ANNOT=[ANNOT;bitshift(A(i+3,2),-2)];  
        ATRTIME=[ATRTIME;A(i+2,1)+bitshift(A(i+2,2),8)+...
                bitshift(A(i+1,1),16)+bitshift(A(i+1,2),24)];
        i=i+3;
    elseif annoth==60
        % nothing to do!
    elseif annoth==61
        % nothing to do!
    elseif annoth==62
        % nothing to do!
    elseif annoth==63
        hilfe=bitshift(bitand(A(i,2),3),8)+A(i,1);
        hilfe=hilfe+mod(hilfe,2);
        i=i+hilfe/2;
    else
        % ANNOT高6位，ATRTIME低10位
        ATRTIME=[ATRTIME;bitshift(bitand(A(i,2),3),8)+A(i,1)];  % 第二列低2位左8和第一列拼
        ANNOT=[ANNOT;bitshift(A(i,2),-2)];  % 第二列高6位
   end;
   i=i+1;
end;
ANNOT(length(ANNOT))=[];       % last line = EOF (=0)
ATRTIME(length(ATRTIME))=[];   % last line = EOF
clear A;
ATRTIME= (cumsum(ATRTIME))/sfreq; % 计算累计和/采样频率
ind= find(ATRTIME <= TIME(end));  % 只保留在截取时间内的索引
ATRTIMED= ATRTIME(ind);   % 截取时间范围内有用的事件发生时间
ANNOT=round(ANNOT);  % 取整？
ANNOTD= ANNOT(ind);  % 截取时间范围内有用的事件类型
% 整个采样序列 ATRTIME 事件时间点 ANNOT 事件类型
% 截取时间段内 ATRTIMED 事件时间点 ANNOTD 事件类型

%------ DISPLAY DATA ------------------------------------------------------
% 
figure(1); clf, box on, hold on
plot(TIME, M(:,1),'r');  % 第一导联
if nosig==2
    plot(TIME, M(:,2),'b');  % 如果有第二导联
end;
for k=1:length(ATRTIMED)
    text(ATRTIMED(k),0,num2str(ANNOTD(k)));  % 添加R
end; 
% 后面是其他的了
xlim([TIME(1), TIME(end)]);
xlabel('Time / s'); ylabel('Voltage / mV');
string=['ECG signal ',DATAFILE];
title(string);
fprintf(1,'\\n$> DISPLAYING DATA FINISHED \n');

% -------------------------------------------------------------------------
fprintf(1,'\\n$> ALL FINISHED \n');