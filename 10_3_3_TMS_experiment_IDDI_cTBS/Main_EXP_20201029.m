% msgbox('������Ϊ���؟�2020��TMSʵ�����~');
%% ������Ϣ�Ǽǣ�
clear all
close all
par=input('�����뱻�Ա�ţ�');
turn=input('��������ʽʵ����ţ���1 2 3 4 5�Σ���');
TMSint=40;%input('������TMS�̼�ǿ�ȣ�');

% ��ȡ������������Ϣ
% cd 10_3_2_TMS_experiment_IDDI_2020
% ordercode=bsliang_gainORDERnum(par);
% cd ..

% if mod(par,2) % ����Ϊ1������
%     oddTag='(�������)�������/t,�Ҽ�һ��/d';
% else          % ����Ϊ0��ż��
%     oddTag='(ż�����)���һ��/d���Ҽ�����/t';
% end

% if ORDERnum<25 %�������б��<25������
%     lrTag='���ԣ�����';
% else
%     lrTag='���ԣ�����';
% end

% % ��ϰʱ�ı��Ա��
% if mod(par,2) % ����Ϊ1������
%     if ordercode<25 %�������б��<25������
%         practice_code=1; %��������
%     else
%         practice_code=25; %��������
%     end
% else          % ����Ϊ0��ż��
%     if ordercode<25 %�������б��<25������
%         practice_code=2; %����ż��
%     else
%         practice_code=26; %����ż��
%     end
% end

% uiwait(msgbox({['��ţ�',num2str(par)],...
%     ['��ʽʵ��ڼ��Σ�',num2str(turn)],...
%     ['����ƽ�����б�ţ�',num2str(ordercode)],...
%     ['���԰�������',oddTag],...
%     ['���Դ̼��е����ڰ���ͷ�Ӧ�֣�',lrTag],...
%     ['��ϰʱ�ı��Ա�ţ�',num2str(practice_code)],...
%     ['TMS�̼�ǿ�ȣ�90%RMT����',num2str(TMSint)]},...
%     '��ȷ�ϱ�����Ϣ','help'));


% %% ��ϰ(��һ��ʵ�飩
% if turn==1
%     cd 10_5_practiceinEXP
% 
%     % step1: ��Ϥbapa����������
%     lbsCP2_practice;
% 
%     % step2: ��Ϥbapa���ֱ�����
%     uiwait(msgbox({'���ļ��У�DI_practice','������������õ�ȫ�����ñ�����������/��ĸ��������ٰ�ȷ��'}));
% 
%     % step3��bapa�Ķ�identification
%     pause(2);
%     lbsCP2_TMSEXP_20190925(practice_code,1);
%     % �������ԣ�1
%     % ż�����ԣ�2
%     % �������ԣ�25
%     % ż�����ԣ�26
%     
%     cd ..
%     cd 10_6_practiceinEXP_diti
%     
%     % step1: ��Ϥditi����������
%     lbsCP2_practice;
% 
%     % step2: ��Ϥditi���ֱ�����
%     uiwait(msgbox({'���ļ��У�DI_practice','������������õ�ȫ�����ñ�����������/��ĸ��������ٰ�ȷ��'}));
%     cd ..
%     
% else
%     %% ��ϰ���ڶ�/����ʵ�飩
%     cd 10_6_practiceinEXP_diti
% 
%     % step1: diti�Ķ�idenfication
%     pause(2);
%     lbsCP2_TMSEXP_20190925(practice_code,1);
%     % �������ԣ�1
%     % ż�����ԣ�2
%     % �������ԣ�25
%     % ż�����ԣ�26
%     
%     cd ..
% end

%% ��ʽʵ�飨��һ/��/����ʵ�飩
close all
cd 10_3_2_TMS_experiment_IDDI_2020
lbsCP2_TMSEXP_20201022(par,turn,TMSint);
cd ..