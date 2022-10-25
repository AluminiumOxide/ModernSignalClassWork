%% 先加载118和119的数据，每次调用wfdb太慢了
clear
clc
close all

num = '118';

path24 = ['./dataset/database3/',num,'e24'];
path18 = ['./dataset/database3/',num,'e18'];
path12 = ['./dataset/database3/',num,'e12'];
path06 = ['./dataset/database3/',num,'e06'];
path00 = ['./dataset/database3/',num,'e00'];
path_6 = ['./dataset/database3/',num,'e_6'];
pathinf = ['./dataset/database1/',num,''];

M_24 = rdsamp(path24);
M_18 = rdsamp(path18);
M_12 = rdsamp(path12);
M_06 = rdsamp(path06);
M_00 = rdsamp(path00);
M__6 = rdsamp(path_6);
M_inf = rdsamp(pathinf);

clearvars path24 path18 path12 path06 path00 path_6 pathinf

save([num2str(num),'.mat'])
