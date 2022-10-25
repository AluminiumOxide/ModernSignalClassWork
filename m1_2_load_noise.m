%% 先加载118和119的数据，每次调用wfdb太慢了
clear
clc
close all

pathbw = ['./dataset/database3/bw'];
pathem = ['./dataset/database3/em'];
pathma = ['./dataset/database3/ma'];
path118 = ['./dataset/database1/118'];
path119 = ['./dataset/database1/119'];

M_bw = rdsamp(pathbw);
M_em = rdsamp(pathem);
M_ma = rdsamp(pathma);
M_118 = rdsamp(path118);
M_119 = rdsamp(path119);


clearvars pathbw pathem pathma path118 path119

save(['noise','.mat'])