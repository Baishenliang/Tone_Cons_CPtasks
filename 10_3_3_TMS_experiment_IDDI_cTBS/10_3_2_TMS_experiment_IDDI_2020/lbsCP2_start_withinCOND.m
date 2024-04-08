function lbsCP2_start_withinCOND(par_code_in,session,w_subj_cond_i,turn_index,TMSinten,resp_h)
    global is_def_range par_code par_name par_age display_instruct w_subj_cond noise_filename adjust_k Di_stimcluster Di_xaxis ses2_cond adjust_noise_k
    par_code = par_code_in;
    %���ڱ��Ϊǰһ��ı��ԣ��̼����ԣ����ַ�Ӧ�����ڱ��Ϊ��һ��ı��ԣ��̼����ԣ����ַ�Ӧ��
    
    % BSLiang 20201028 input intensity to determine trial length
    load TMScycletime
    if TMSinten>70
        msgbox('ǿ�ȳ���70����ȷ���µ�cycle����');
        pause;
    else
        TMScycletime_idv=TMScycletime(TMSinten);
    end
    
    global singleburst_trialLength doubleburst_trialLength
    singleburst_trialLength=TMScycletime_idv.singleburst;
    doubleburst_trialLength=TMScycletime_idv.doubleburst;
    
    DATA=lbsCP2_loadDATA();

    % ��Ӧ����TMS�̼���������
    global resp_hand
    resp_hand=resp_h;
    %   stimSITE   NUMBER
    %   Left iTBS    1
    %   Left cTBS    2
    %   Right iTBS   3
    %   Right cTBS   4
    %   Sham         5 
    
    if isequal(session,'_def_range_')
        data_temp=DATA(par_code).def_range;
        is_def_range=1;
    elseif isequal(session,'_practice_')
        data_temp=DATA(par_code).practice;
        is_def_range=0;
    elseif isequal(session,'_Id_Di_')
        data_temp=DATA(par_code).Id_Di;
        is_def_range=0;
    end
    
    w_subj_cond=data_temp.w_subj_cond;
    ses2_cond=data_temp.ses2_cond{w_subj_cond_i};
    w_subj_stimsource=data_temp.w_subj_stimsource;
    noise_filename=data_temp.noise_filename{w_subj_cond_i};
    adjust_noise_k=data_temp.indSNRs_k(w_subj_cond_i);
    soundk=data_temp.soundk{w_subj_cond_i};
    Di_stimcluster=data_temp.Di_stimcluster{w_subj_cond_i};
    Di_xaxis=data_temp.Di_xaxis{w_subj_cond_i};
    stimsourcetype=data_temp.stimsourcetype;
    const_reptimes=data_temp.const_reptimes(w_subj_cond_i);
    
    par_name=DATA(par_code).par_info.name;
    par_age=DATA(par_code).par_info.age;
    
    global stimfilename
    % stimfilename������Ĵ̼��ļ����֣�stimfile���Ǵ���̼��ı���
    stimfilename = data_temp.filename{w_subj_cond_i};

    global Zjudge_text Mjudge_text to_test_substep addnoise
    to_test_substep=w_subj_cond_i;
    addnoise=data_temp.addnoise(w_subj_cond_i);
    
    ajk=load(soundk);
    adjust_k=ajk.adjust_k; % ���Ҷ�ϵ��


    %��������������
    %Zjudge_text ����ǵ�һ���жϰ�ť���������Ҫô��/di1/,Ҫô��/һ��/
    %Mjudge_text ����ǵڶ����жϰ�ť���������Ҫô��/ti1/,Ҫô��/����/

    %���ߵ���������Ӧ���ֱ���ʲô����
    Zjudge_text=data_temp.Zjudge_text{w_subj_cond_i};
    Mjudge_text=data_temp.Mjudge_text{w_subj_cond_i};
    
    global stimfile stimperc
    % stimfilename������Ĵ̼��ļ����֣�stimfile���Ǵ���̼��ı���

    % ���stimfile��ÿ��session�ж���һ��
    try
        %�����ܲ��ܼ������stimfile
        load(w_subj_stimsource{1,w_subj_cond_i});
        stimfile=[];
        if isequal(stimsourcetype,'_ind_')
            eval(['stimfile=par_EXPdata(par_code).',data_temp.filename{w_subj_cond_i}{1},';']);
        elseif isequal(stimsourcetype,'_avg_')
            eval(['stimfile=par_EXPdata.',data_temp.filename{w_subj_cond_i}{1},';']);
        end
        
        load(w_subj_stimsource{2,w_subj_cond_i});
        stimperc=[];
        if isequal(stimsourcetype,'_ind_')
            eval(['stimperc=xs_perc_struct(par_code).xs_perc.',data_temp.filename{w_subj_cond_i}{2},';']);
        elseif isequal(stimsourcetype,'_avg_')
            eval(['stimperc=xs_perc_struct.xs_perc.',data_temp.filename{w_subj_cond_i}{2},';']);
        end
        
    catch
        disp('��Ч����!');%�ļ������ڣ����򲻻ᱬը
    end
    % Zjudge_test��Mjudge_test��ÿ��session�в�һ��

    global randomorder stimsteplength measure_type interact_type staircase_stoprunstage staircase_stoprunchange staircase_id_dis
    %��������������
    %randomorder �����ר�Ÿ����㶨�̼������õ�������У���˴̼���1-21����˳���Ų��ģ���randomorder��������������ŵ�Ҫ��
    %Zjudge_text ����ǵ�һ���жϰ�ť���������Ҫô��/di1/,Ҫô��/һ��/
    %Mjudge_text ����ǵڶ����жϰ�ť���������Ҫô��/ti1/,Ҫô��/����/
    %stimteplength ����������̼����еĳ��ȣ�һ��Ҳ���ǵ���stimfile�ĳ��ȣ�����������ñȽ϶಻һһչ��
    measure_type=data_temp.measure_type(w_subj_cond_i); 
    interact_type=data_temp.interact_type(w_subj_cond_i); %[20190614,����Ҫ��]
    staircase_id_dis=data_temp.staircase_id_dis(w_subj_cond_i);
    
    %�����ʹ�ú㶨�̼�����ÿ���̼������Գ���5�Σ�����˳�����
    %randomorder=Shuffle(repmat(1:size(stimfile,2),1,3));
    %[20190428:����ͬ���̼��ظ�����]
    randomorder=[];
%     if staircase_id_dis == 2
%         const_reptimes=2;
%     elseif staircase_id_dis ==1 || 3
%         const_reptimes=1;
%     end
    for const_rep=1:const_reptimes
        randomorder=[randomorder,Shuffle(1:size(stimfile,2))];
    end

    %��������ָ�ظ����Σ��������Ѿ���bug�ˣ���Ϊ���3��������template��������õģ���������Ҫ�����ֶ����ˡ�o(�i�n�i)o
    %���ڽ��е��ǽ��ݷ���step1_measure_type=2��
    stimsteplength=size(stimfile,2);
    %�������д̼�������=stimfile�ĳ���
    
    staircase_stoprunstage=data_temp.staircase_stoprunstage(w_subj_cond_i); %[20190614,����Ҫ��]
    staircase_stoprunchange=data_temp.staircase_stoprunchange(w_subj_cond_i); %[20190614,����Ҫ��]

    if staircase_id_dis==1 %rep_step_num��ָͬһ��block�ظ����ٴΣ�ע������const_rep��ָһ��block�ж��ٸ�session��
        rep_step_num=1;
    else
        rep_step_num=1;
    end
    
    disp(' ');
    disp(' ');
    disp(['Subj Name: ',par_name,', Age: ',num2str(par_age),' Subj Code: ',num2str(par_code_in),' Order Code: ',num2str(bsliang_gainORDERnum(par_code_in))]);
    disp('================================================================================');
    disp(['This is condition ',ses2_cond,'. It is the No.',num2str(w_subj_cond_i),' within condition of the subject.']);
    disp('================================================================================');
    disp(['ses2_cond = ',ses2_cond]);
    disp(['noise_filename = ',noise_filename]);
    disp(['soundk = ',soundk]);
    disp(['stimsourcetype = ',stimsourcetype]);
    disp(['const_reptimes = ',num2str(const_reptimes)]);
    disp(['stimfilename = ',stimfilename{1},' ',stimfilename{2}]);
    disp(['to_test_substep = ',num2str(to_test_substep)]);
    disp(['addnoise = ',num2str(addnoise)]);   
    disp(['adjust_k = ',num2str(adjust_k)]);
    disp(['KEY1 = ',Zjudge_text,' KEY2 = ',Mjudge_text]);
    disp(['STIM_source = ',w_subj_stimsource{1,w_subj_cond_i}]);
    disp(['measure_type = ',num2str(measure_type)]);
    disp(['interact_type = ',num2str(interact_type)]);
    disp(['staircase_id_dis = ', num2str(staircase_id_dis)]);
    
    
    istest=1; %=1: ���ԣ�������������
    if ~istest
        for rep_step=1:rep_step_num
        
            if rep_step==1
                display_instruct=1;
            else
                display_instruct=0;
            end

            output=lbsCP_parScreen();
            % output������������ɣ�{[],[]}����ϸ�����ݣ����ұߵ�[]�Ǳ��Ե���ֵ
            %��������������staircaseģʽ������constant stimuli��������Ҫд��һ��if������=��=��

            if isequal(session,'_def_range_')
                if w_subj_cond_i <=2
                    DATA(par_code).def_range.data(rep_step,w_subj_cond_i,turn_index).rawdata=output.rawdata;
                    DATA(par_code).def_range.data(rep_step,w_subj_cond_i,turn_index).half_threshold=[stimperc',output.half_threshold(:,2)];
                    DATA(par_code).def_range.data(rep_step,w_subj_cond_i,turn_index).threshold_boundaries=output.threshold_boundaries;
                else
                    DATA(par_code).def_range.data(rep_step,w_subj_cond_i,turn_index).rawdata=output.rawdata;
                    DATA(par_code).def_range.data(rep_step,w_subj_cond_i,turn_index).half_threshold=output.half_threshold(:,2);
                    DATA(par_code).def_range.data(rep_step,w_subj_cond_i,turn_index).threshold_boundaries=output.threshold_boundaries;
                end
            elseif isequal(session,'_Id_Di_') && staircase_id_dis==2
                DATA(par_code).Id_Di.data(rep_step,w_subj_cond_i,turn_index).rawdata=output.rawdata;
                DATA(par_code).Id_Di.data(rep_step,w_subj_cond_i,turn_index).half_threshold=[stimperc',output.half_threshold(:,2)];
                DATA(par_code).Id_Di.data(rep_step,w_subj_cond_i,turn_index).threshold_boundaries=output.threshold_boundaries;
            elseif isequal(session,'_Id_Di_') && staircase_id_dis==3
                DATA(par_code).Id_Di.data(rep_step,w_subj_cond_i,turn_index).rawdata=output.rawdata;
                DATA(par_code).Id_Di.data(rep_step,w_subj_cond_i,turn_index).half_threshold=output.half_threshold(:,2);
                DATA(par_code).Id_Di.data(rep_step,w_subj_cond_i,turn_index).threshold_boundaries=output.threshold_boundaries;
            end
             lbsCP2_saveDATA(DATA);

        end
    end
    
    clear all