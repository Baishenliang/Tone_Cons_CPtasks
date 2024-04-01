function lbsCP2_TMSEXP_20201022(par,turn,TMSinten)
    % par: code of a subject
    % turn: which turn (five turns for each subject: 
    %       Left iTBS (LI)、Left cTBS (LC)、Right iTBS（RI）、Right cTBS（RC）、Sham )
    %       !! Take care of the order !!
    % TMSinten: intensity of TMS stimulation
    
    is_test_turns=0; % 1时不进行练习也不开始实验
    skip_practice=1; % 1时跳过练习
    
    %% 导入数据，确定turn以及block的顺序
    DATA=lbsCP2_loadDATA();
    
    load('input/blockmatrix.mat');
    load('input/counterShams.mat');
    par_max=max(cell2mat(output(2,:)));
    par_mat=output(:,(bsliang_gainORDERnum(par)-1)*end/par_max+1:bsliang_gainORDERnum(par)*end/par_max); %get subject's list
    
    turn_types=unique(par_mat(3,:),'stable');
    turn_Tag=turn_types{turn};
    
    turn_mat=cell(size(par_mat,1),size(par_mat,2)/length(turn_types));
    
    turn_m=1;
    for par_m=1:size(par_mat,2)
        if isequal(par_mat{3,par_m},turn_Tag)
            turn_mat(:,turn_m)=par_mat(:,par_m);
            turn_m=turn_m+1;
        end
    end

    %% 确定turn
%   stimSITE   NUMBER
%   40Hz tACS	1
%   4Hz tACS	2
%   Sham	3

    turn_index=0;
%       Left iTBS (LI)、Left cTBS (LC)、Right iTBS（RI）、Right cTBS（RC）、Sham )
    if isequal(turn_Tag,'40Hz tACS')
        turn_index=1;
        tms_MSG='40Hz tACS';
    elseif isequal(turn_Tag,'4Hz tACS')
        turn_index=2;
        tms_MSG='4Hz tACS'; 
    elseif isequal(turn_Tag,'Sham')
        turn_index=3;
        tms_MSG=counterShams{bsliang_gainORDERnum(par)};
    end
    
    %% 确定反应手
    ordercode=bsliang_gainORDERnum(par);
    if ordercode <=par_max/2
        resp_hand=1; % Left hand
    else
        resp_hand=2; % Right hand
    end
    
    if resp_hand==1
        lrTag='左手';
    elseif resp_hand==2
        lrTag='右手';
    end

    %% 确定按键顺序
    if mod(par,2) % 余数为1，奇数
        oddTag='(奇数编号)左键二声/t，右键一声/d';
    else          % 余数为0，偶数
        oddTag='(偶数编号)左键一声/d，右键二声/t';
    end
    
    %% 练习时的被试编号，用于保持练习与实验反应手一致
    if mod(par,2) % 余数为1，奇数
        if resp_hand==1 % 用左手反应
            practice_code=1; %左手奇数 （这些所谓左右是在practice里的，那里左右用的还是古老的order编号，小于25左脑这样）
        elseif resp_hand==2 % 用右手反应
            practice_code=25; %右手奇数
        end
    else          % 余数为0，偶数
        if resp_hand==1 % 用左手反应
            practice_code=2; %左手偶数
        elseif resp_hand==2 % 用右手反应
            practice_code=26; %右手偶数
        end
    end

    if ~is_test_turns && ~skip_practice
        show_par_name=DATA(par).par_info.name;
    else
        show_par_name=[num2str(par),'测试姓名'];
    end
    
    uiwait(msgbox({['编号：',num2str(par)],...
    ['被试平衡序列编号：',num2str(ordercode)],...
    ['姓名：',show_par_name],...
    ['正式实验第几次：',num2str(turn)],...
    ['电刺激类型：',tms_MSG],...
    ['被试按键次序：',oddTag],...
    ['被试反应手：',lrTag],...
    ['练习时的被试编号：',num2str(practice_code)]}));

    
    %% 一个turn开始前先进行练习
    if ~is_test_turns && ~skip_practice % 不是测试且不跳过练习时练习
        % 练习(第一次实验）
        if turn==1
            cd(['..',filesep,'10_5_practiceinEXP']);

            % step1: 熟悉bapa：按键任务
            lbsCP2_practice;

            % step2: 熟悉bapa：分辨任务
    %         uiwait(msgbox({'打开文件夹：DI_practice','点击声音（不用点全），让被试区分声调/声母，做完后再按确定'}));

            % step3：bapa的短identification
            pause(2);
            lbsCP2_TMSEXP_20190925(practice_code,1);
            % 奇数左脑：1
            % 偶数左脑：2
            % 奇数右脑：25
            % 偶数右脑：26

            cd(['..',filesep,'10_6_practiceinEXP_diti']);

            % step1: 熟悉diti：按键任务
            lbsCP2_practice;

            % step2: 熟悉diti：分辨任务
    %         uiwait(msgbox({'打开文件夹：DI_practice','点击声音（不用点全），让被试区分声调/声母，做完后再按确定'}));
            cd(['..',filesep,'10_3_2_TMS_experiment_IDDI_2020']);

        else
            % 练习（第二/三次实验）
            cd(['..',filesep,'10_6_practiceinEXP_diti']);

            % step1: diti的短idenfication
            pause(2);
            lbsCP2_TMSEXP_20190925(practice_code,1);
            % 奇数左脑：1
            % 偶数左脑：2
            % 奇数右脑：25
            % 偶数右脑：26

            cd(['..',filesep,'10_3_2_TMS_experiment_IDDI_2020']);
        end

        close all
    end
    
    %% 正式实验
    uiwait(msgbox({['编号：',num2str(par)],...
    ['被试平衡序列编号：',num2str(ordercode)],...
    ['姓名：',show_par_name],...
    ['正式实验第几次：',num2str(turn)],...
    ['电刺激类型：',tms_MSG],...
    ['被试按键次序：',oddTag],...
    ['被试反应手：',lrTag]}));

    % 施加TMS
    uiwait(msgbox('电刺激就绪后按【确定】开始电刺激和实验。'));
    % 倒计时：
        
    TMSBEHAV_tic=tic;    
    for w_block=1:size(turn_mat,2)
%   BLOCK	NAME        NUMBER
%   A       T_CLEAR_ID      1
%   B       P_CLEAR_ID      2
%   C       T_NOISE_ID      3
%   D       P_NOISE_ID      4
        block_index=0;
        if isequal(turn_mat{4,w_block},'A')
            block_index=1;
        elseif isequal(turn_mat{4,w_block},'B')
            block_index=2;
        elseif isequal(turn_mat{4,w_block},'C')
            block_index=3;
        elseif isequal(turn_mat{4,w_block},'D')
            block_index=4;
        end
        if is_test_turns
            disp([turn_mat{4,w_block},' ',num2str(block_index)]);
        else
            lbsCP2_start_withinCOND(par,'_Id_Di_',block_index,turn_index,TMSinten,resp_hand);
        end
    end
    TMSBEHAV_toc=toc(TMSBEHAV_tic);
    disp(['正式实验消耗',num2str(TMSBEHAV_toc/60),'分钟']);
    
    
    