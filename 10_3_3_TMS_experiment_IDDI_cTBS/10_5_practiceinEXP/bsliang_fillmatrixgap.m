    function matrix=bsliang_fillmatrixgap(cell)
        max_rownum=0;
        for i=1:size(cell,2)
            lst_tmp=cell{i};
            if size(lst_tmp,1)> max_rownum
                max_rownum = size(lst_tmp,1);
            end
        end
        matrix=[];
        for i=1:size(cell,2)
            lst_tmp=cell{i};
            if size(lst_tmp,1)< max_rownum
                add_tmp = max_rownum - size(lst_tmp,1);
                lst_tmp=[lst_tmp;mean(lst_tmp)*ones(add_tmp,1)];
            end
            matrix=[matrix,lst_tmp];
        end        