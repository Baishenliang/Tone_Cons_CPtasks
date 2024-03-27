function [X,Y]=bsliang_gainPeakx_from_DIandRT(Xlst,Ylst)

% 注释那个方法太复杂了，而且是错的，错在镜像对称那里，其实不是沿着AC重点对称，是沿着未知数XB_p对称，但是这个数都未知，怎么求
% % 因为一个peak可能峰点会歪，从这个程序里可以算出从discrimination或者反应时计算出来的peak点的位置。
% % 理论假设为peak点（记为B')总是落在等腰三角形的端点，而三个测量点必定都在等腰三角形的边上（分别记为A/B/C三点，其中B为测出的最高点）。
% % 实际上，要分四种情况讨论：
% % （1） AB在同一条边，且C比A高；
% % （2） AB在同一条边，且C比A低；
% % （3） BC在同一条边，且C比A高；
% % （4） BC在同一条边，且C比A低。
% %事实上，由于等腰三角形的对称性，(1)(3)为同一情况，(2)(4)为同一情况；
% 
% % 通过ABC的坐标求B'的横坐标是本函数的重点
% % 推导过程见图：instructions/DI拟合peak_方法一.jpg
% 
% % X坐标变换：原点改为A C中点
% Xlst_t=Xlst-(Xlst(1)+Xlst(3))/2;
% % 点变换：BC同一条边，图形镜像对称：
% mirror=0;
% if Xlst_t(2)>0
%     mirror=1;
%     Xlst_t=(-1)*Xlst_t;
% end
% 
% XA=Xlst_t(1);
% XB=Xlst_t(2);
% XC=Xlst_t(3);
% YA=Ylst(1);
% YB=Ylst(2);
% YC=Ylst(3);
% 
% bsliang = @(XG)((XA-XG)/(XB-XG)-(YA-YC)/(YB-YC));
% options = optimset('TolX',0.00000000000000000001);
% XG=fzero(bsliang,XA,options);
% 
% if mirror
%     XB_p=(-1)*(XG+XC)/2+(Xlst(1)+Xlst(3))/2;
% else
%     XB_p=(XG+XC)/2+(Xlst(1)+Xlst(3))/2;
% end

% 上面的方法出问题了，错在镜像对称那里，其实不是沿着AC重点对称，是沿着未知数XB_p对称，但是这个数都未知，怎么求
% 新方法：instructions/DI拟合peak_方法二.jpg

syms X0 Y0
XA=Xlst(1);
XB=Xlst(2);
XC=Xlst(3);
YA=Ylst(1);
YB=Ylst(2);
YC=Ylst(3);

eq1 = (X0-XA)^2/(X0-XB)^2-(Y0-YA)^2/(Y0-YB)^2==0;
eq2 = (X0-XA)^2/(X0-XC)^2-(Y0-YA)^2/(Y0-YC)^2==0;
eq3 = (X0-XB)^2/(X0-XC)^2-(Y0-YB)^2/(Y0-YC)^2==0;

eqs = [eq1 eq2 eq3];
S=solve(eqs,[X0 Y0]);
X=double(S.X0);
Y=double(S.Y0);
X=X(logical(double(X>Xlst(1)).*double(X<Xlst(3)).*double(Y>Ylst(2))));
Y=Y(logical(double(X>Xlst(1)).*double(X<Xlst(3)).*double(Y>Ylst(2))));