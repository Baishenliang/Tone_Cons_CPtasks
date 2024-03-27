%===========================================
%         这个程序存在的意义在于合成音位连续体
%===========================================
%         版权归中科院心理所杜忆课题组所有
%         有问题可联系梁柏燊，liangbs@psych.ac.cn
%============================================
function [ba1_pa1_contin,ba1_pa1_contin_cat]=morph_ba_pa(vot_cut_point_sp,pa1,fs,nosteps)
    pa1_head=pa1(1:round(vot_cut_point_sp(1)));
    pa1_asp=[];
    for c_cp=1:nosteps % cut aspiration into 20 portions
        pa1_asp{c_cp}=pa1(round(vot_cut_point_sp(c_cp))+1:round(vot_cut_point_sp(c_cp+1)));
    end
    pa1_vowel=pa1(round(vot_cut_point_sp(nosteps+1))+1:end);

    ba1_pa1_contin=[];
    for cc_cp=1:(nosteps+1)
        ba1_pa1_contin{cc_cp}=pa1_head;
    end
    for c_ccp=1:nosteps
        for c_cccp=nosteps:-1:c_ccp
          ba1_pa1_contin{c_cccp+1}=[ba1_pa1_contin{c_cccp+1};pa1_asp{c_ccp}];
        end
    end
    ba1_pa1_contin_cat=[];
    for cc_cp=1:(nosteps+1)
        ba1_pa1_contin{cc_cp}=[ba1_pa1_contin{cc_cp};pa1_vowel];
    end
    for cc_cp=1:(nosteps+1)
        sound(ba1_pa1_contin{cc_cp},fs);
        pause(0.5);
        ba1_pa1_contin_cat=[ba1_pa1_contin_cat,zeros(1,0.5*fs),ba1_pa1_contin{cc_cp}'];
    end
end