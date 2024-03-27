function [block_orders,turn_orders]=bsliang_getindorder(par)
    turn_orders=zeros(1,4);
    block_orders=zeros(4,4);
    
    DATA=lbsCP2_loadDATA();
    
    load('input/blockmatrix.mat');
    par_max=max(cell2mat(output(2,:)));
    par_mat=output(:,(bsliang_gainORDERnum(par)-1)*end/par_max+1:bsliang_gainORDERnum(par)*end/par_max); %get subject's list
    
    turn_types=unique(par_mat(3,:),'stable');
    for turn=1:4
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
            turn_orders(1,turn)=turn_index;
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
                block_orders(turn,w_block)=block_index;
           end
    end
        