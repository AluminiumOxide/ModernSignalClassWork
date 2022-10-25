function plotDetCoefHelper(f,C,L,TIME)
%Copyright 2016 The MathWorks, Inc.
 D = detcoef(C,L,'cells');
% % [cD1, cD2, cD3, cD4, cD5] = detcoef(C,L,[1,2,3,4,5]);
figure; 
% set(gcf,'Position', [402         139        1378         923]);
subplot(6,1,1)
plot(TIME,f); axis tight; grid on; title('Original Signal');xlabel('times /s');
subplot(6,1,2) 
% h = stem([TIME,0]',dyadup(D{1}));  % dyadup 对时间序列进行二元插值，每隔一个元素插入一个0元素，得到一个时间序列
h = stem(D{1});
% stem是针状图
h.ShowBaseLine = 'off';
h.Marker = '.';
h.MarkerSize = 2;
axis tight; grid on; title('Level 1 Details');

subplot(6,7,[15,20])
% h = stem([TIME,zeros(1,3)]', dyadup(dyadup(D{2})));
h = stem(D{2});
h.ShowBaseLine = 'off';
h.Marker = '.';
h.MarkerSize = 2;
axis tight; grid on;title('Level 2 Details');

subplot(6,7,[22,26])
% h = stem([TIME,zeros(1,7)]', dyadup(dyadup(dyadup(D{3}))));
h = stem(D{3});
h.ShowBaseLine = 'off';
h.Marker = '.';
h.MarkerSize = 2;
axis tight; grid on; title('Level 3 Details');

subplot(6,7,[29,32])
% h = stem([TIME,zeros(1,15)]', dyadup(dyadup(dyadup(dyadup(D{4})))));
h = stem(D{4});
h.ShowBaseLine = 'off';
h.Marker = '.';
h.MarkerSize = 2;
axis tight; grid on;title('Level 4 Details');

subplot(6,6,[31,33])
% h = stem([TIME,zeros(1,47)]', dyadup(dyadup(dyadup(dyadup(dyadup(D{5}))))));
h = stem(D{5});
h.ShowBaseLine = 'off';
h.Marker = '.';
h.MarkerSize = 2;
axis tight; grid on;title('Level 5 Details');

A5 = appcoef(C,L,'db4',5);

subplot(6,6,[34,36])
% h = stem([TIME,zeros(1,47)]', dyadup(dyadup(dyadup(dyadup(dyadup(D{5}))))));
h = stem(A5);
h.ShowBaseLine = 'off';
h.Marker = '.';
h.MarkerSize = 2;
axis tight; grid on;title('Level 5 approxs');