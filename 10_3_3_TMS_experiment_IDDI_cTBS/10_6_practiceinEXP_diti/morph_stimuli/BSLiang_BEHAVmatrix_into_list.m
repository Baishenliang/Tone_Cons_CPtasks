function [BEHAV_stim_lst,BEHAV_stim_lst_DIS] = BSLiang_BEHAVmatrix_into_list(BEHAV_stim_mat)
%这个函数将行为实验生成的7*7个steps：
% 程序是直接挪用SNR预实验的程序，本着能不改就不改的原则，实验刺激阵列也是跟着SNR使用的刺激去安排
% 第一行：（等同于SNR的第一行）7行7列的矩阵转变成49列（即是将每一行合并到同一列里面去）
% 第二行：（等同于SNR的第二行：信噪比类型）step1到step7，7个条件，用以表示不同的step
% 第三行：（等同于SNR的第三行：按什么键是正确的）因为连续体判断无绝对对错，这一行无实际用途，仅为适应程序而保留
% 第四行：（新加的一行）用于标示另一维度的step，step1到step7，比如这是个phoneme判断，则这里表示的是tone维度

% 下面这个mat拿来测试本程序：
%BEHAV_stim_mat={'A','B','C','D','E';'F','G','H','I','J';'K','L','M','N','O';'P','Q','R','S','T';'U','V','W','X','Y'};

rowlen = size(BEHAV_stim_mat,1);
collen = size(BEHAV_stim_mat,2);

%现在求重复次数矩阵：在PSE附近的多重复
rep_mat=ones(rowlen,collen);

if mod(rowlen,2)==0 %偶数
    rep_mat_row=[1:rowlen/2,rowlen/2:-1:1];
elseif mod(rowlen,2)==1 %奇数
    rep_mat_row=[1:floor(rowlen/2),ceil(rowlen/2),floor(rowlen/2):-1:1];
end

if mod(collen,2)==0 %偶数
    rep_mat_col=[1:collen/2,collen/2:-1:1];
elseif mod(collen,2)==1 %奇数
    rep_mat_col=[1:floor(collen/2),ceil(collen/2),floor(collen/2):-1:1];
end

for i=1:rowlen
    for j=1:rowlen
        rep_mat(i,j)=floor((rep_mat_row(i)+rep_mat_col(j))/2);
    end
end


BEHAV_stim_lst=cell(4,sum(sum(rep_mat,1),2));
stim_acc=0;
for repp=1:max(reshape(rep_mat,1,[]))
    rep_mat_temp=rep_mat-(repp-1);
    for row = 1:rowlen
        for col = 1:collen
            if rep_mat_temp(row,col)>0
                stim_acc=stim_acc+1;
                BEHAV_stim_lst{1,stim_acc}=BEHAV_stim_mat{row,col};
                BEHAV_stim_lst{2,stim_acc}=col;
                BEHAV_stim_lst{3,stim_acc}=1;
                BEHAV_stim_lst{4,stim_acc}=row;
            end
        end
    end
end

% 下面生成discrimination实验用的材料：
dis_step=2; %discrimination的差异刺激对隔多少个steps：
fs=44100;
ISI=0.5; %0.5s
stim_label=1:collen;
dis_stim_label = [stim_label(1:end-dis_step)*10+stim_label(1+dis_step:end),stim_label(1+dis_step:end)*10+stim_label(1:end-dis_step),stim_label*10+stim_label];
dis_sync_label = [2*ones(1,2*(length(stim_label)-dis_step)),ones(1,length(stim_label))]; %[2同步，1不同步]
colllen_dis=length(dis_stim_label);

BEHAV_stim_lst_DIS_mat=cell(rowlen,colllen_dis);
%下面对BEHAV_stim_mat进行刺激合成操作
for row_dis = 1:rowlen
    for col_dis = 1:colllen_dis
        lab_temp = dis_stim_label(col_dis);
        lab_temp_1 = floor(lab_temp/10); %十位数
        lab_temp_2 = mod(lab_temp,10); %个位数
        BEHAV_stim_lst_DIS_mat{row_dis,col_dis}=[BEHAV_stim_mat{row_dis,lab_temp_1};zeros(ISI*fs,1);BEHAV_stim_mat{row_dis,lab_temp_2}];
    end
end

BEHAV_stim_lst_DIS=cell(4,rowlen*colllen_dis);
%下面进行重排列，捏成一行
for row = 1:rowlen
    for col = 1:colllen_dis
        BEHAV_stim_lst_DIS{1,(row-1)*colllen_dis+col}=BEHAV_stim_lst_DIS_mat{row,col};
        BEHAV_stim_lst_DIS{2,(row-1)*colllen_dis+col}=dis_stim_label(col);
        BEHAV_stim_lst_DIS{3,(row-1)*colllen_dis+col}=dis_sync_label(col);
        BEHAV_stim_lst_DIS{4,(row-1)*colllen_dis+col}=row;
    end
end

% 下面是测试这个函数的程序：
% BEHAV_stim_mat = cell(7,7);
% for P=1:7
%     for T=1:7
%         BEHAV_stim_mat(P,T)={[P;T]};
%     end
% end
% [BEHAV_stim_lst,BEHAV_stim_lst_DIS] = BSLiang_BEHAVmatrix_into_list(BEHAV_stim_mat);
