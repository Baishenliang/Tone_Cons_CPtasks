% msgbox('本程序为梁柏燊2020年TMS实验程序~');
%% 被试信息登记：
clear all
close all
par=input('请输入被试编号：');
turn=input('请输入正式实验序号（第1 2 3 4 5次）：');
TMSint=40;%input('请输入TMS刺激强度：');

% 读取被试左右脑信息
% cd 10_3_2_TMS_experiment_IDDI_2020
% ordercode=bsliang_gainORDERnum(par);
% cd ..

% if mod(par,2) % 余数为1，奇数
%     oddTag='(奇数编号)左键二声/t,右键一声/d';
% else          % 余数为0，偶数
%     oddTag='(偶数编号)左键一声/d，右键二声/t';
% end

% if ORDERnum<25 %被试序列编号<25，左脑
%     lrTag='左脑，左手';
% else
%     lrTag='右脑，右手';
% end

% % 练习时的被试编号
% if mod(par,2) % 余数为1，奇数
%     if ordercode<25 %被试序列编号<25，左脑
%         practice_code=1; %左脑奇数
%     else
%         practice_code=25; %右脑奇数
%     end
% else          % 余数为0，偶数
%     if ordercode<25 %被试序列编号<25，左脑
%         practice_code=2; %左脑偶数
%     else
%         practice_code=26; %右脑偶数
%     end
% end

% uiwait(msgbox({['编号：',num2str(par)],...
%     ['正式实验第几次：',num2str(turn)],...
%     ['被试平衡序列编号：',num2str(ordercode)],...
%     ['被试按键次序：',oddTag],...
%     ['被试刺激靶点所在半球和反应手：',lrTag],...
%     ['练习时的被试编号：',num2str(practice_code)],...
%     ['TMS刺激强度（90%RMT）：',num2str(TMSint)]},...
%     '请确认被试信息','help'));


% %% 练习(第一次实验）
% if turn==1
%     cd 10_5_practiceinEXP
% 
%     % step1: 熟悉bapa：按键任务
%     lbsCP2_practice;
% 
%     % step2: 熟悉bapa：分辨任务
%     uiwait(msgbox({'打开文件夹：DI_practice','点击声音（不用点全），让被试区分声调/声母，做完后再按确定'}));
% 
%     % step3：bapa的短identification
%     pause(2);
%     lbsCP2_TMSEXP_20190925(practice_code,1);
%     % 奇数左脑：1
%     % 偶数左脑：2
%     % 奇数右脑：25
%     % 偶数右脑：26
%     
%     cd ..
%     cd 10_6_practiceinEXP_diti
%     
%     % step1: 熟悉diti：按键任务
%     lbsCP2_practice;
% 
%     % step2: 熟悉diti：分辨任务
%     uiwait(msgbox({'打开文件夹：DI_practice','点击声音（不用点全），让被试区分声调/声母，做完后再按确定'}));
%     cd ..
%     
% else
%     %% 练习（第二/三次实验）
%     cd 10_6_practiceinEXP_diti
% 
%     % step1: diti的短idenfication
%     pause(2);
%     lbsCP2_TMSEXP_20190925(practice_code,1);
%     % 奇数左脑：1
%     % 偶数左脑：2
%     % 奇数右脑：25
%     % 偶数右脑：26
%     
%     cd ..
% end

%% 正式实验（第一/二/三次实验）
close all
cd 10_3_2_TMS_experiment_IDDI_2020
lbsCP2_TMSEXP_20201022(par,turn,TMSint);
cd ..