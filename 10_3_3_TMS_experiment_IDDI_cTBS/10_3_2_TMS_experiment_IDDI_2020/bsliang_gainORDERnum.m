function ORDERnum=bsliang_gainORDERnum(PARnum)
% 原本安排的是48个被试，因此被试实验顺序的平衡也是按着这个来的。
%但是事实上被试可能或多或少，因此真正实验的时候每个被试都有一个自己的被试编号
%（跟第一次实验一样），同时有一个ORDER编号用来确定被试做实验的block顺序。ORDER编号是可以重复的。

% tranMAT=[1:47;2:48]';
 tranMAT=[1,1;... % 这是BSLiang本人，不纳入平衡序列和数据; 
          142,2;...% Larynx 女
          202,1;...% Larynx 女
          201,3;...% Larynx 女
          55,4;...% Larynx 男
          104,5;...% Larynx 女
          206,6;...% Larynx 女
          207,7;...% Larynx 女 ！退出实验
          229,7;...% Larynx 男
          203,8;...% Larynx 男
          210,9;...% Larynx 女
          216,10;...% Larynx 女
          215,11;...% Larynx 女 ！退出实验 
          234,11;...% Larynx 女
          212,12;...% Larynx 女
          211,13;...% Larynx 女
          123,14;...% Larynx 男
          217,15;...% Larynx 女
          209,16;...% Larynx 男
          205,17;...% Larynx 男
          218,18;...% Larynx 男
          139,19;...% Larynx 男
          204,20;...% Larynx 男 ！退出实验
          231,20;...% Larynx 男
          224,21;...% Larynx 男 ！退出实验
          240,21;...% Larynx 女
          225,22;...% Larynx 男
          226,23;...% Larynx 女
          232,24;...% Larynx 男
          247,1;... % Larynx 男
          253,2;... % Larynx 女
          118,25;...% Tongue 女 ！退出实验
          261,25;...% Tongue 女
          221,26;...% Tongue 女
          222,27;...% Tongue 女
          219,28;...% Tongue 女
          220,29;...% Tongue 女
          223,30;...% Tongue 女
          228,31;...% Tongue 女
          230,32;...% Tongue 女
          233,33;...% Tongue 女
          239,34;...% Tongue 女
          237,35;...% Tongue 女
          241,36;...% Tongue 男
          243,37;...% Tongue 女
          245,38;...% Tongue 男
          249,39;...% Tongue 男
          251,40;...% Tongue 男
          250,41;...% Tongue 男
          254,42;...% Tongue 男
          255,43;...% Tongue 男
          258,44;...% Tongue 男
          259,45;...% Tongue 男
          260,46;...% Tongue 男
          262,47;...% Tongue 男
          264,48];% Tongue 男
      
%第一列为被试自己的编号，第二列为被试的ORDER编号。

ORDERnum=tranMAT(tranMAT(:,1)==PARnum,2);