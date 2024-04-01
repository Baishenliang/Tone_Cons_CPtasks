function lbsCP2_TMSEXP_20201022(par,turn,TMSinten)
    % par: code of a subject
    % turn: which turn (five turns for each subject: 
    %       Left iTBS (LI)��Left cTBS (LC)��Right iTBS��RI����Right cTBS��RC����Sham )
    %       !! Take care of the order !!
    % TMSinten: intensity of TMS stimulation
    
    is_test_turns=0; % 1ʱ��������ϰҲ����ʼʵ��
    skip_practice=1; % 1ʱ������ϰ
    
    %% �������ݣ�ȷ��turn�Լ�block��˳��
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

    %% ȷ��turn
%   stimSITE   NUMBER
%   40Hz tACS	1
%   4Hz tACS	2
%   Sham	3

    turn_index=0;
%       Left iTBS (LI)��Left cTBS (LC)��Right iTBS��RI����Right cTBS��RC����Sham )
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
    
    %% ȷ����Ӧ��
    ordercode=bsliang_gainORDERnum(par);
    if ordercode <=par_max/2
        resp_hand=1; % Left hand
    else
        resp_hand=2; % Right hand
    end
    
    if resp_hand==1
        lrTag='����';
    elseif resp_hand==2
        lrTag='����';
    end

    %% ȷ������˳��
    if mod(par,2) % ����Ϊ1������
        oddTag='(�������)�������/t���Ҽ�һ��/d';
    else          % ����Ϊ0��ż��
        oddTag='(ż�����)���һ��/d���Ҽ�����/t';
    end
    
    %% ��ϰʱ�ı��Ա�ţ����ڱ�����ϰ��ʵ�鷴Ӧ��һ��
    if mod(par,2) % ����Ϊ1������
        if resp_hand==1 % �����ַ�Ӧ
            practice_code=1; %�������� ����Щ��ν��������practice��ģ����������õĻ��ǹ��ϵ�order��ţ�С��25����������
        elseif resp_hand==2 % �����ַ�Ӧ
            practice_code=25; %��������
        end
    else          % ����Ϊ0��ż��
        if resp_hand==1 % �����ַ�Ӧ
            practice_code=2; %����ż��
        elseif resp_hand==2 % �����ַ�Ӧ
            practice_code=26; %����ż��
        end
    end

    if ~is_test_turns && ~skip_practice
        show_par_name=DATA(par).par_info.name;
    else
        show_par_name=[num2str(par),'��������'];
    end
    
    uiwait(msgbox({['��ţ�',num2str(par)],...
    ['����ƽ�����б�ţ�',num2str(ordercode)],...
    ['������',show_par_name],...
    ['��ʽʵ��ڼ��Σ�',num2str(turn)],...
    ['��̼����ͣ�',tms_MSG],...
    ['���԰�������',oddTag],...
    ['���Է�Ӧ�֣�',lrTag],...
    ['��ϰʱ�ı��Ա�ţ�',num2str(practice_code)]}));

    
    %% һ��turn��ʼǰ�Ƚ�����ϰ
    if ~is_test_turns && ~skip_practice % ���ǲ����Ҳ�������ϰʱ��ϰ
        % ��ϰ(��һ��ʵ�飩
        if turn==1
            cd(['..',filesep,'10_5_practiceinEXP']);

            % step1: ��Ϥbapa����������
            lbsCP2_practice;

            % step2: ��Ϥbapa���ֱ�����
    %         uiwait(msgbox({'���ļ��У�DI_practice','������������õ�ȫ�����ñ�����������/��ĸ��������ٰ�ȷ��'}));

            % step3��bapa�Ķ�identification
            pause(2);
            lbsCP2_TMSEXP_20190925(practice_code,1);
            % �������ԣ�1
            % ż�����ԣ�2
            % �������ԣ�25
            % ż�����ԣ�26

            cd(['..',filesep,'10_6_practiceinEXP_diti']);

            % step1: ��Ϥditi����������
            lbsCP2_practice;

            % step2: ��Ϥditi���ֱ�����
    %         uiwait(msgbox({'���ļ��У�DI_practice','������������õ�ȫ�����ñ�����������/��ĸ��������ٰ�ȷ��'}));
            cd(['..',filesep,'10_3_2_TMS_experiment_IDDI_2020']);

        else
            % ��ϰ���ڶ�/����ʵ�飩
            cd(['..',filesep,'10_6_practiceinEXP_diti']);

            % step1: diti�Ķ�idenfication
            pause(2);
            lbsCP2_TMSEXP_20190925(practice_code,1);
            % �������ԣ�1
            % ż�����ԣ�2
            % �������ԣ�25
            % ż�����ԣ�26

            cd(['..',filesep,'10_3_2_TMS_experiment_IDDI_2020']);
        end

        close all
    end
    
    %% ��ʽʵ��
    uiwait(msgbox({['��ţ�',num2str(par)],...
    ['����ƽ�����б�ţ�',num2str(ordercode)],...
    ['������',show_par_name],...
    ['��ʽʵ��ڼ��Σ�',num2str(turn)],...
    ['��̼����ͣ�',tms_MSG],...
    ['���԰�������',oddTag],...
    ['���Է�Ӧ�֣�',lrTag]}));

    % ʩ��TMS
    uiwait(msgbox('��̼������󰴡�ȷ������ʼ��̼���ʵ�顣'));
    % ����ʱ��
        
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
    disp(['��ʽʵ������',num2str(TMSBEHAV_toc/60),'����']);
    
    
    