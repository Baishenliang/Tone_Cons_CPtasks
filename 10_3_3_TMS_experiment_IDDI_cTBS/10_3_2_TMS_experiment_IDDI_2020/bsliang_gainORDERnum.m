function ORDERnum=bsliang_gainORDERnum(PARnum)
% ԭ�����ŵ���48�����ԣ���˱���ʵ��˳���ƽ��Ҳ�ǰ���������ġ�
%������ʵ�ϱ��Կ��ܻ����٣��������ʵ���ʱ��ÿ�����Զ���һ���Լ��ı��Ա��
%������һ��ʵ��һ������ͬʱ��һ��ORDER�������ȷ��������ʵ���block˳��ORDER����ǿ����ظ��ġ�

% tranMAT=[1:47;2:48]';
 tranMAT=[1,1;... % ����BSLiang���ˣ�������ƽ�����к�����; 
          142,2;...% Larynx Ů
          202,1;...% Larynx Ů
          201,3;...% Larynx Ů
          55,4;...% Larynx ��
          104,5;...% Larynx Ů
          206,6;...% Larynx Ů
          207,7;...% Larynx Ů ���˳�ʵ��
          229,7;...% Larynx ��
          203,8;...% Larynx ��
          210,9;...% Larynx Ů
          216,10;...% Larynx Ů
          215,11;...% Larynx Ů ���˳�ʵ�� 
          234,11;...% Larynx Ů
          212,12;...% Larynx Ů
          211,13;...% Larynx Ů
          123,14;...% Larynx ��
          217,15;...% Larynx Ů
          209,16;...% Larynx ��
          205,17;...% Larynx ��
          218,18;...% Larynx ��
          139,19;...% Larynx ��
          204,20;...% Larynx �� ���˳�ʵ��
          231,20;...% Larynx ��
          224,21;...% Larynx �� ���˳�ʵ��
          240,21;...% Larynx Ů
          225,22;...% Larynx ��
          226,23;...% Larynx Ů
          232,24;...% Larynx ��
          247,1;... % Larynx ��
          253,2;... % Larynx Ů
          118,25;...% Tongue Ů ���˳�ʵ��
          261,25;...% Tongue Ů
          221,26;...% Tongue Ů
          222,27;...% Tongue Ů
          219,28;...% Tongue Ů
          220,29;...% Tongue Ů
          223,30;...% Tongue Ů
          228,31;...% Tongue Ů
          230,32;...% Tongue Ů
          233,33;...% Tongue Ů
          239,34;...% Tongue Ů
          237,35;...% Tongue Ů
          241,36;...% Tongue ��
          243,37;...% Tongue Ů
          245,38;...% Tongue ��
          249,39;...% Tongue ��
          251,40;...% Tongue ��
          250,41;...% Tongue ��
          254,42;...% Tongue ��
          255,43;...% Tongue ��
          258,44;...% Tongue ��
          259,45;...% Tongue ��
          260,46;...% Tongue ��
          262,47;...% Tongue ��
          264,48];% Tongue ��
      
%��һ��Ϊ�����Լ��ı�ţ��ڶ���Ϊ���Ե�ORDER��š�

ORDERnum=tranMAT(tranMAT(:,1)==PARnum,2);