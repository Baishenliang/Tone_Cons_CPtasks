function bsliang_getSNRfromK_Main(subjlsts)
    load DATA
    for subj=subjlsts
        Ks=DATA(subj).Id_Di.indSNRs_k(1:2);
        disp(['SUBJ ',num2str(subj)]);
        disp(['TONE ',num2str(bsliang_getSNRfromK(Ks(1)))]);
        disp(['PHON ',num2str(bsliang_getSNRfromK(Ks(2)))]);
    end
end