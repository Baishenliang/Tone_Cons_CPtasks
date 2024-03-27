function lbsCP2_TMSEXP_20190925(par,turn)
    % par: code of a subject
    % turn: which turn (three turns for each subject: sham, larynx, and
    % tongue)
%     msgbox(['请确认：被试编号为',num2str(par),',被试ORDER编号为',num2str(bsliang_gainORDERnum(par)),'。']);
%     pause();
    DATA=lbsCP2_loadDATA();
    
    load('input/blockmatrix.mat');
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
    
%   stimSITE   NUMBER
%       L        1
%       S1       2
%       T        3
%       S2       4

        turn_index=0;
        if isequal(turn_Tag,'L')
            turn_index=1;
            tms_MSG='Larynx';
        elseif isequal(turn_Tag,'S1')
            turn_index=2;
            tms_MSG='Sham1';          
        elseif isequal(turn_Tag,'T')
            turn_index=3;
            tms_MSG='Tongue';
        elseif isequal(turn_Tag,'S2')
            turn_index=4;
            tms_MSG='Sham2';
        end
        msgbox(['Now the TMS condition is:',tms_MSG,'. Press any key if stimulation is finished.']);
        pause();
    
    TMSBEHAV_tic=tic;    
    for w_block=1:size(turn_mat,2)
%   Id_Di	BLOCK	NAME        NUMBER
%   Id      A       T_CLEAR_ID      1
%   Id      B       P_CLEAR_ID      2
%   Id      C       T_NOISE_ID      3
%   Id      D       P_NOISE_ID      4
%    Di     A       T_CLEAR_DI      5
%    Di     B       P_CLEAR_DI      6
%    Di     C       T_NOISE_DI      7
%    Di     D       P_NOISE_DI      8

        block_index=0;
        if isequal(turn_mat{4,w_block},'Id')
            if isequal(turn_mat{5,w_block},'A')
                block_index=1;
            elseif isequal(turn_mat{5,w_block},'B')
                block_index=2;
            elseif isequal(turn_mat{5,w_block},'C')
                block_index=3;
            elseif isequal(turn_mat{5,w_block},'D')
                block_index=4;
            end
        elseif isequal(turn_mat{4,w_block},'Di')
            if isequal(turn_mat{5,w_block},'A')
                block_index=5;
            elseif isequal(turn_mat{5,w_block},'B')
                block_index=6;
            elseif isequal(turn_mat{5,w_block},'C')
                block_index=7;
            elseif isequal(turn_mat{5,w_block},'D')
                block_index=8;
            end
        end
        lbsCP2_start_withinCOND(par,'_Id_Di_',block_index,turn_index);
    end
    TMSBEHAV_toc=toc(TMSBEHAV_tic);
    disp(['正式实验消耗',num2str(TMSBEHAV_toc/60),'分钟']);
    
    
    