function F0_range=bsliang_getvalue_F0range(tonestart,tonestop)
    startp = 50;%10;
    endp = 100;%100;
    %tonestart:tone1��struct������F0��
    %tonestop:tone2��struct������F0��
    %startp��ʾ����F0ʱ��tone_m��ʼF0>0������ĵ���
    %endp��ʾ����F0ʱ��end��ʼ��ǰ���ĵ���
    
    tone_1=createMobject;
    tone_1=updateFieldOfMobject(tone_1,'waveform',tonestart);
    tone_1=executeSTRAIGHTanalysisM(tone_1);

    tone_2=createMobject;
    tone_2=updateFieldOfMobject(tone_2,'waveform',tonestop);
    tone_2=executeSTRAIGHTanalysisM(tone_2);
    
   %make sure that F0 contours are aligned:
    tone_1.F0(tone_2.F0==0)=0;
    tone_2.F0(tone_1.F0==0)=0;
    
    tone1_pos=find(tone_1.F0);
    tone1_beg=tone1_pos(1);
    
    tone2_pos=find(tone_2.F0);
    tone2_beg=tone2_pos(1);
    
%     if length(tone_1.F0)~=length(tone_2.F0)
%         disp('������ʼ�ͽ����ļ�F0���Ȳ�һ');
%     end
    tone_beg=round(mean([tone1_beg,tone2_beg]));
    tone_end=round(mean([length(tone_1.F0),length(tone_2.F0)]));
    F0_range=[tone_beg+startp,tone_end-endp];
    
    
    
    

    
    