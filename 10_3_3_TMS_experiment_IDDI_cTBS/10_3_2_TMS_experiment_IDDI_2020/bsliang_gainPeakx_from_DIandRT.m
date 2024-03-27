function [X,Y]=bsliang_gainPeakx_from_DIandRT(Xlst,Ylst)

% ע���Ǹ�����̫�����ˣ������Ǵ�ģ����ھ���Գ������ʵ��������AC�ص�Գƣ�������δ֪��XB_p�Գƣ������������δ֪����ô��
% % ��Ϊһ��peak���ܷ����ᣬ�������������������discrimination���߷�Ӧʱ���������peak���λ�á�
% % ���ۼ���Ϊpeak�㣨��ΪB')�������ڵ��������εĶ˵㣬������������ض����ڵ��������εı��ϣ��ֱ��ΪA/B/C���㣬����BΪ�������ߵ㣩��
% % ʵ���ϣ�Ҫ������������ۣ�
% % ��1�� AB��ͬһ���ߣ���C��A�ߣ�
% % ��2�� AB��ͬһ���ߣ���C��A�ͣ�
% % ��3�� BC��ͬһ���ߣ���C��A�ߣ�
% % ��4�� BC��ͬһ���ߣ���C��A�͡�
% %��ʵ�ϣ����ڵ��������εĶԳ��ԣ�(1)(3)Ϊͬһ�����(2)(4)Ϊͬһ�����
% 
% % ͨ��ABC��������B'�ĺ������Ǳ��������ص�
% % �Ƶ����̼�ͼ��instructions/DI���peak_����һ.jpg
% 
% % X����任��ԭ���ΪA C�е�
% Xlst_t=Xlst-(Xlst(1)+Xlst(3))/2;
% % ��任��BCͬһ���ߣ�ͼ�ξ���Գƣ�
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

% ����ķ����������ˣ����ھ���Գ������ʵ��������AC�ص�Գƣ�������δ֪��XB_p�Գƣ������������δ֪����ô��
% �·�����instructions/DI���peak_������.jpg

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