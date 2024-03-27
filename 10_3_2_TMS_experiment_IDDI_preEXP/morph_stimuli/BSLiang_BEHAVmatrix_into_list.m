function [BEHAV_stim_lst,BEHAV_stim_lst_DIS] = BSLiang_BEHAVmatrix_into_list(BEHAV_stim_mat)
%�����������Ϊʵ�����ɵ�7*7��steps��
% ������ֱ��Ų��SNRԤʵ��ĳ��򣬱����ܲ��ľͲ��ĵ�ԭ��ʵ��̼�����Ҳ�Ǹ���SNRʹ�õĴ̼�ȥ����
% ��һ�У�����ͬ��SNR�ĵ�һ�У�7��7�еľ���ת���49�У����ǽ�ÿһ�кϲ���ͬһ������ȥ��
% �ڶ��У�����ͬ��SNR�ĵڶ��У���������ͣ�step1��step7��7�����������Ա�ʾ��ͬ��step
% �����У�����ͬ��SNR�ĵ����У���ʲô������ȷ�ģ���Ϊ�������ж��޾��ԶԴ���һ����ʵ����;����Ϊ��Ӧ���������
% �����У����¼ӵ�һ�У����ڱ�ʾ��һά�ȵ�step��step1��step7���������Ǹ�phoneme�жϣ��������ʾ����toneά��

% �������mat�������Ա�����
%BEHAV_stim_mat={'A','B','C','D','E';'F','G','H','I','J';'K','L','M','N','O';'P','Q','R','S','T';'U','V','W','X','Y'};

rowlen = size(BEHAV_stim_mat,1);
collen = size(BEHAV_stim_mat,2);

%�������ظ�����������PSE�����Ķ��ظ�
rep_mat=ones(rowlen,collen);

if mod(rowlen,2)==0 %ż��
    rep_mat_row=[1:rowlen/2,rowlen/2:-1:1];
elseif mod(rowlen,2)==1 %����
    rep_mat_row=[1:floor(rowlen/2),ceil(rowlen/2),floor(rowlen/2):-1:1];
end

if mod(collen,2)==0 %ż��
    rep_mat_col=[1:collen/2,collen/2:-1:1];
elseif mod(collen,2)==1 %����
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

% ��������discriminationʵ���õĲ��ϣ�
dis_step=2; %discrimination�Ĳ���̼��Ը����ٸ�steps��
fs=44100;
ISI=0.5; %0.5s
stim_label=1:collen;
dis_stim_label = [stim_label(1:end-dis_step)*10+stim_label(1+dis_step:end),stim_label(1+dis_step:end)*10+stim_label(1:end-dis_step),stim_label*10+stim_label];
dis_sync_label = [2*ones(1,2*(length(stim_label)-dis_step)),ones(1,length(stim_label))]; %[2ͬ����1��ͬ��]
colllen_dis=length(dis_stim_label);

BEHAV_stim_lst_DIS_mat=cell(rowlen,colllen_dis);
%�����BEHAV_stim_mat���д̼��ϳɲ���
for row_dis = 1:rowlen
    for col_dis = 1:colllen_dis
        lab_temp = dis_stim_label(col_dis);
        lab_temp_1 = floor(lab_temp/10); %ʮλ��
        lab_temp_2 = mod(lab_temp,10); %��λ��
        BEHAV_stim_lst_DIS_mat{row_dis,col_dis}=[BEHAV_stim_mat{row_dis,lab_temp_1};zeros(ISI*fs,1);BEHAV_stim_mat{row_dis,lab_temp_2}];
    end
end

BEHAV_stim_lst_DIS=cell(4,rowlen*colllen_dis);
%������������У����һ��
for row = 1:rowlen
    for col = 1:colllen_dis
        BEHAV_stim_lst_DIS{1,(row-1)*colllen_dis+col}=BEHAV_stim_lst_DIS_mat{row,col};
        BEHAV_stim_lst_DIS{2,(row-1)*colllen_dis+col}=dis_stim_label(col);
        BEHAV_stim_lst_DIS{3,(row-1)*colllen_dis+col}=dis_sync_label(col);
        BEHAV_stim_lst_DIS{4,(row-1)*colllen_dis+col}=row;
    end
end

% �����ǲ�����������ĳ���
% BEHAV_stim_mat = cell(7,7);
% for P=1:7
%     for T=1:7
%         BEHAV_stim_mat(P,T)={[P;T]};
%     end
% end
% [BEHAV_stim_lst,BEHAV_stim_lst_DIS] = BSLiang_BEHAVmatrix_into_list(BEHAV_stim_mat);
