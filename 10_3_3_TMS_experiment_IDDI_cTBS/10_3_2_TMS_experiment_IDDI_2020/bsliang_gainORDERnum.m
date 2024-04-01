function ORDERnum=bsliang_gainORDERnum(PARnum)
% 原本安排的是48个被试，因此被试实验顺序的平衡也是按着这个来的。
%但是事实上被试可能或多或少，因此真正实验的时候每个被试都有一个自己的被试编号
%（跟第一次实验一样），同时有一个ORDER编号用来确定被试做实验的block顺序。ORDER编号是可以重复的。

% tranMAT=[1:47;2:48]';
 tranMAT=[1,1;... % 这是测试数据，不纳入平衡序列和数据; 
                  2,2;... % 左手，偶数
                  3,3;... % 左手，奇数
                  4,4;... % 左手，偶数
                  12,12;... % 左手，偶数
                  13,13;... % 右手，奇数
                  23,24;... % 右手，奇数
                  22,22];  % 右手，奇数
      
%第一列为被试自己的编号（可以无限增加）
%第二列为被试的ORDER编号，在input/blockmatrix.mat中规定的participant list里循环。

ORDERnum=tranMAT(tranMAT(:,1)==PARnum,2);