function [ba1_pa1_contin,ba1_pa1_contin_cat,fs] = bsliang_TANDOM_ratedcontinuum(revisedData,nosteps)
    stepsize=nosteps+1; %��ʷԭ�������stepsiz�����������nosteps��һ
    A_Rate = revisedData.temporalMorphingRate.spectrum;
    B_Rate = repmat(max(A_Rate),length(A_Rate),1);
    Morphed_rates = 1-linspace(0,1,stepsize);
    ba1_pa1_contin=[];
    ba1_pa1_contin_cat=[];
    for i=1:length(Morphed_rates)
        revisedData_temp = revisedData;
        This_Rate = Morphed_rates(i)*A_Rate + (1-Morphed_rates(i))*B_Rate;
        revisedData_temp.temporalMorphingRate.spectrum=This_Rate;
        revisedData_temp.temporalMorphingRate.frequency=This_Rate;
        revisedData_temp.temporalMorphingRate.aperiodicity=This_Rate;
        revisedData_temp.temporalMorphingRate.F0=This_Rate;
        revisedData_temp.temporalMorphingRate.time=This_Rate;
        %�˴��õ����°��TAMDOM_Straight,����ǰ�����ӵ�·����лл��
        morphedSignal=generateMorphedSpeechNewAP(revisedData_temp);
        fs=morphedSignal.samplintFrequency;
        sound_temp=morphedSignal.outputBuffer/max(abs(morphedSignal.outputBuffer))*0.99;
        ba1_pa1_contin{i}=sound_temp;
        ba1_pa1_contin_cat=[ba1_pa1_contin_cat,zeros(1,0.5*fs),sound_temp'];
%         sound(sound_temp,morphedSignal.samplintFrequency);
%         pause((length(This_Rate)/morphedSignal.samplintFrequency)+0.5);
    end
    
    