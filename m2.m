clear
clc
close all

load 118.mat

size_M = size(M_00);
from = 360*300+360*120*10+1;
to = from+360*10-1;
M_list = {M_24,M_18,M_12,M_06,M_00,M__6};
clearvars M_24 M_18 M_12 M_06 M_00 M__6
M_pure = M_list{5}(from:to,2);
M_cut = M_list{1}(from:to,2);

dwtmode('per','nodisplay');
wname = 'sym6';
level = 5;
[C, L] = wavedec(M_cut,level,wname);
TIME = 1/360:1/360:10;

plotDetCoefHelper(M_cut,C,L,TIME);

